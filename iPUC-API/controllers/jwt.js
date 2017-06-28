'use strict';

var jsonwebtoken    = require('jsonwebtoken');
var config          = require('../config/config.json');


var jwt = function (req, res, next) {

    if(req.headers.authorization){
        var token = req.headers.authorization.split(/\s+/)[1];
        jsonwebtoken.verify(token, config.jwt_secret, function(err, decoded) {
            if(!err) next();
            else{
                res.status(401);
                res.json({
                    message: 'Unauthorized',
                    status_code: 401
                });
            }
        });
    }else{
        res.status(401);
        res.json({
            message: 'Unauthorized',
            status_code: 401
        });
    }

};

module.exports = jwt;