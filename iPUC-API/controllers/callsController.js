'use strict';

var callsController = {};

var config          = require('../config/config.json');
var mysql           = require('mysql');
var jsonwebtoken    = require('jsonwebtoken');

//REDIS
var redis           = require('redis');
var pubsub          = require('node-redis-pubsub');

//CONFIG REDIS CLIENT
var redisClient	    = redis.createClient();
var url             = process.env.REDIS_URL;
var configRedis     = { url: url };
var clientPubsub    = new pubsub(configRedis);

//ONESIGNAL
var oneSignal       = require('onesignal')(config.onesignal.key, config.onesignal.app, true);

var Calls           = require('../models/calls_mysql.js');
var Users           = require('../models/users_mysql.js');
var Contacts        = require('../models/contacts_mysql.js');
var Devices         = require('../models/devices_mysql.js');
var Channels         = require('../models/channels_mysql.js');
var Callcenters         = require('../models/callcenters_mysql.js');

redisClient.on("error", function (err) {
    console.log("Error " + err);
});

callsController.get = function (req, res, next) {
    var call = new Calls();
    call.find('first', {where: 'id = '+ req.params.id}, function(err, rows, fields) {
        if (err) return next(err);
        resWithRelations(res, rows)
    });
};

callsController.put = function (req, res, next) {
    req.body.id = req.params.id;
    req.body.updated_at = jps_makeTimestamp(Date.now());

    if(req.body.status == 'ACCEPTED')
        req.body.accepted_at = jps_makeTimestamp(Date.now());

    var call = new Calls(req.body);
    call.save(function(err, rows, fields) {
        if (err) { return next(err); }
        call.find('first', {where: 'id = '+ req.params.id}, function(err, rows, fields) {
            if (err) return next(err);

            switch (rows.status){
                case 'NOT_ACCEPTED':
                case 'MISSED':
                case 'TRANSFERRED':
                case 'FINALIZED': {
                    redisClient.hdel('STATUS_OF_CALL', [rows.called_id], function (err, res) {}); //DELETE REDIS STATUS CALLED
                    redisClient.hdel('STATUS_OF_CALL', [rows.caller_id], function (err, res) {}); //DELETE REDIS STATUS CALLER
                    redisClient.hdel('CalledCallsInPulse:'+rows.called_id, 'init_data', function (err, res) {});//DELETE REDIS CALL

                    changeCommunicationStatus(rows.called_id, 'ONLINE');
                    changeCommunicationStatus(rows.caller_id, 'ONLINE');

                    clientPubsub.emit('accountEventsUpdate', {
                        user_id: rows.called_id,
                        event_id: rows.id,
                        event_type: (rows.type == 'PRIVATE') ? 'CALL' : 'CALLCENTER_CALL'
                    });//SEND EVENT UPDATE

                    clientPubsub.emit('accountEventsUpdate', {
                        user_id: rows.caller_id,
                        event_id: rows.id,
                        event_type: (rows.type == 'PRIVATE') ? 'CALL' : 'CALLCENTER_CALL'
                    });//SEND EVENT UPDATE

                    break;
                }

                case 'ACCEPTED':{
                    redisClient.hdel('CalledCallsInPulse:'+rows.called_id, 'init_data', function (err, res) {});//DELETE REDIS CALL
                    break;
                }
            }

            resWithRelations(res, rows);
        });
    });
};

callsController.user = function (req, res, next) {
    var token = req.headers.authorization.split(/\s+/)[1];
    jsonwebtoken.verify(token, config.jwt_secret, function(err, decoded) {
        if(err) {
            res.status(401);
            res.json({
                message: 'Unauthorized',
                status_code: 401
            })

            return;
        }

        req.body.init_data = {
            from : decoded.sub,
            to : req.body.user_id,
            payload :{
                type : req.body.type,
                category : 'PRIVATE'
            },
            type : 'init'
        }

        req.body.called_id = req.body.user_id;
        req.body.caller_id = decoded.sub;
        req.body.type = 'PRIVATE';
        req.body.channel_id = null;
        req.body.callcenter_id = null;

        makeCall(req.body, res, next);
    });
}

callsController.callcenter = function (req, res, next) {

    var token = req.headers.authorization.split(/\s+/)[1];
    jsonwebtoken.verify(token, config.jwt_secret, function(err, decoded) {
        if(err) {
            res.status(401);
            res.json({
                message: 'Unauthorized',
                status_code: 401
            })

            return;
        }

        req.body.init_data = {
            from : decoded.sub,
            payload :{
                type : req.body.type,
                category : 'CALLCENTER'
            },
            type : 'init'
        }

        req.body.caller_id = decoded.sub;
        req.body.type = 'CALLCENTER';

        if(req.body.user_id){
            req.body.called_id = req.body.user_id;
            makeCall(req.body, res, next);
        }else{
            var query = 'select * from zukbox.channel_staff ' +
                'inner join zukbox.callcenter_staff ' +
                'on zukbox.channel_staff.staff_id = zukbox.callcenter_staff.id ' +
                'inner join zukbox.users ' +
                'on zukbox.callcenter_staff.member_id = zukbox.users.id ' +
                'where zukbox.channel_staff.channel_id = '+ req.body.channel_id + ' ' +
                'and zukbox.callcenter_staff.status = \'accepted\' ' +
                'and zukbox.callcenter_staff.member_id <> '+ req.body.caller_id;

            var connection = mysql.createConnection(config.db);
            connection.connect(function(err){
                if(!err) {
                    connection.query(query, function(err, rows, fields) {
                        connection.end();
                        if (!err) makeRandomCall(rows, res, req.body, next);
                        else return next(err);
                    });
                }else return next(err);
            });
        }
    });
}

function makeCall(data, res, next) {
    redisClient.hget('STATUS_OF_CALL', data.called_id, function(err, data_redis){

        if(data_redis)
            return res.json({
                status: "BUSY"
            });//IF HAVE CALL RETURN BUSY

        data.init_data.to = data.called_id;
        data.init_data.from = data.caller_id;
        data.init_data = JSON.stringify(data.init_data);

        var call_maker = {
            called_id       : data.called_id,
            caller_id       : data.caller_id,
            type            : data.type,
            init_data       : data.init_data,
            channel_id      : data.channel_id,
            callcenter_id   : data.callcenter_id,
            created_at      : jps_makeTimestamp(Date.now()),
            updated_at      : jps_makeTimestamp(Date.now())
        }

        var call = new Calls(call_maker);
        call.save(function(err, rows_save, fields) {
            if (err) return next(err);
            call.find('first', {where: 'id = '+ rows_save.insertId}, function(err, rows_find, fields) {
                if (err) return next(err);

                rows_find.init_data = JSON.parse(rows_find.init_data);
                rows_find.init_data.payload.call_id = rows_find.id;

                if(rows_find.channel_id)
                    rows_find.init_data.payload.channel_id = rows_find.channel_id;

                clientPubsub.emit('callInPulse', {
                    user_id: rows_find.called_id,
                    init_data: rows_find.init_data,
                    notifier_id: rows_find.caller_id
                });//SEND NEW CALL TO SOCKET

                redisClient.hset(['CalledCallsInPulse:'+rows_find.called_id, 'init_data', JSON.stringify(rows_find.init_data)], function (err, res) {});//SET NEW CALL IN REDIS
                redisClient.hset(['STATUS_OF_CALL', rows_find.called_id, 'BUSY'], function (err, res) {});//SET STATUS FROM CALLED
                redisClient.hset(['STATUS_OF_CALL', rows_find.caller_id, 'BUSY'], function (err, res) {});//SET STATUS FROM CALLER
                changeCommunicationStatus(rows_find.caller_id, 'BUSY');
                changeCommunicationStatus(rows_find.called_id, 'BUSY');

                //SEND PUSH NOTIFICATION
                sendPush(rows_find);

                setTimeout(function () {
                    var old_call = new Calls();
                    old_call.find('first', {where: 'id = '+ rows_find.id}, function(err, rows_timeout, fields) {
                        switch (rows_timeout.status){
                            case 'IN_PULSE':{
                                redisClient.hdel('CalledCallsInPulse:'+rows_timeout.called_id, 'init_data', function (err, res) {});
                                redisClient.hdel('STATUS_OF_CALL', [rows_timeout.caller_id], function (err, res) {});
                                redisClient.hdel('STATUS_OF_CALL', [rows_timeout.called_id], function (err, res) {});

                                changeCommunicationStatus(rows_timeout.caller_id, 'ONLINE');
                                changeCommunicationStatus(rows_timeout.called_id, 'ONLINE');

                                rows_timeout.updated_at = jps_makeTimestamp(Date.now());
                                rows_timeout.status = 'MISSED';
                                var missed_call = new Calls(rows_timeout);
                                missed_call.save();
                            }
                        }
                    });

                }, 60000);//TIMEOUT CALL

                rows_find.init_data = JSON.stringify(rows_find.init_data)
                resWithRelations(res, rows_find);
            });
        });
    });//VERIFY HAVE CALL IN_PULSE
}

function makeRandomCall(data, res, body, next) {
    var connecteds = [];
    var disconnecteds = [];

    for(var i = 0; i < data.length; i++){
        if(data[i].id != body.caller_id) {
            switch (data[i].communication_status) {
                case 'OFFLINE': {
                    disconnecteds.push(data[i]);
                    break;
                }
                case 'ONLINE': {
                    connecteds.push(data[i]);
                    break;
                }
            }
        }
    }

    if(connecteds.length > 0) {
        var called_index = Math.floor((Math.random() * disconnecteds.length));
        var called_id = connecteds[called_index].id;

        body.called_id = called_id;
        makeCall(body, res, next);
    }else if(disconnecteds.length > 0) {
        var called_index = Math.floor((Math.random() * disconnecteds.length));
        var called_id = disconnecteds[called_index].id;

        body.called_id = called_id;
        makeCall(body, res, next);
    }else{
        return res.json({
            status: "BUSY"
        });//IF HAVE CALL RETURN BUSY
    }
}

function changeCommunicationStatus(id, status) {
    var user = new Users();
    if(status == 'ONLINE'){
        user.find('first', {where: 'id = '+ id}, function(err, rows_user, fields) {
            if (err) return next(err);

            if(rows_user.connection_status == 'DISCONNECT')
                status = 'OFFLINE';

            var user_data = {
                id: id,
                communication_status: status
            }

            user.set(user_data);
            user.save();
            notifyChangedStatus(id, status);
        });

    }else{
        var user_data = {
            id: id,
            communication_status: status
        }

        user.set(user_data);
        user.save();
        notifyChangedStatus(id, status);
    }
}

function notifyChangedStatus(id, status) {
    var contact = new Contacts();

    contact.find('all', {where: '(contact_id = '+ id +' OR requester_id = '+ id +') AND status = \'ACCEPTED\''}, function (err, rows_find, fields) {
        if (err) return;

        var connected_contact_ids = [];
        for(var i = 0; i < rows_find.length; i++){
            if(rows_find[i].contact_id != id){
                connected_contact_ids.push(rows_find[i].contact_id);
            }else{
                connected_contact_ids.push(rows_find[i].requester_id);
            }
        }

        clientPubsub.emit('userCommunicationStatusChanged', {
            connected_contact_ids: connected_contact_ids,
            user_id: id,
            user_communication_status: status
        });//SEND TO SOCKET
    });
}

function sendPush(call) {
    var user = new Users();
    user.find('first', {where: 'id = '+ call.called_id}, function(err, rows_user, fields) {
        if (err) return;

        if(rows_user.connection_status == 'DISCONNECTED'){
            var device = new Devices();

            device.find('all', {where: 'user_id = '+ call.called_id +' AND status = \'ACTIVE\''}, function(err, rows_devices, fields) {
                if (err) return;

                var include_player_ids = [];
                for(var i = 0; i < rows_devices.length; i++)
                    include_player_ids.push(rows_devices[i].one_signal_id);

                var message = 'Recebendo ligação';

                var data = {
                    event_type: 'CALL',
                    user_id : call.called_id,
                    notifier_id: call.caller_id,
                    init_data: call.init_data,
                    notification_body: 'Você esta recebendo uma ligação. Abra o ZUK.',
                    notification_title: '@' + rows_user.username,
                    notification_time: Math.round(Date.now()/1000)
                };

                oneSignal.createNotification(message, data, include_player_ids);


                setTimeout(function () {
                    var old_call = new Calls();
                    old_call.find('first', {where: 'id = '+ call.id}, function(err, rows_timeout, fields) {
                        switch (rows_timeout.status){
                            case 'IN_PULSE': {
                                sendPush(rows_timeout);
                                break;
                            }
                        }
                    });
                }, 10000);//TIMEOUT CALL

            });
        }
    });
}

function resWithRelations(res, data) {

    var users = new Users();
    users.find('all', {where: 'id = '+ data.called_id +' OR id = '+ data.caller_id}, function(err, rows_users, fields) {

        for (var i = 0; i < rows_users.length; i++){
            delete rows_users[i].password;
            delete rows_users[i].confirmation_token;
            delete rows_users[i].remember_token;
            delete rows_users[i].confirmed;
            delete rows_users[i].new_email;

            switch (rows_users[i].id){
                case data.called_id:
                    data.called = rows_users[i];
                    break;

                case data.caller_id:
                    data.caller = rows_users[i];
                    break;

                default:
                    break;
            }
        }

        delete data.called_id;
        delete data.caller_id;


        if(data.type == 'CALLCENTER') {
            var channel = new Channels();
            channel.find('first', {where: 'id = ' + data.channel_id}, function (err, rows_channel, fields) {
                delete data.channel_id;
                delete data.callcenter_id;

                data.channel = rows_channel;
                var callcenter = new Callcenters();
                callcenter.find('first', {where: 'id = ' + rows_channel.callcenter_id}, function (err, rows_callcenter, fields) {
                    delete data.channel.callcenter_id;
                    data.channel.callcenter = rows_callcenter;

                    res.json(data);
                });

            });

        }
        else{
            delete data.callcenter_id;
            delete data.channel_id;

            res.json(data);
        }
    });

}

function jps_makeTimestamp(dateobj){
    var date = new Date( dateobj );
    var yyyy = date.getFullYear();
    var mm = date.getMonth() + 1;
    var dd = date.getDate();
    var hh = date.getHours();
    var min = date.getMinutes();
    var ss = date.getSeconds();

    var mysqlDateTime = yyyy + '-' + mm + '-' + dd + ' ' + hh + ':' + min + ':' + ss;

    return mysqlDateTime;
}

module.exports = callsController;