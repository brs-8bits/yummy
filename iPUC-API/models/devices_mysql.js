/**
 * Created by OzeiasFurtozo on 30/03/17.
 */

var config = require('../config/config.json');
var mysqlModel = require('mysql-model');

var DevicesModel = mysqlModel.createConnection(config.db);

module.exports = DevicesModel.extend({
    tableName: "devices"
});