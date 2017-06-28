/**
 * Created by OzeiasFurtozo on 22/03/17.
 */
var mysql   = require("mysql");
var config  = require('./config.json');
var pool    = mysql.createPool(config.db);

exports.getConnection = function(callback) {
    pool.getConnection(function(err, conn) {
        console.log(err, conn);

        if(err) {
            return callback(err);
        }
        callback(err, conn);
    });
};