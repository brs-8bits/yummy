/**
 * Created by OzeiasFurtozo on 06/04/17.
 */

var config = require('../config/config.json');
var mysqlModel = require('mysql-model');

var CallcentersModel = mysqlModel.createConnection(config.db);

module.exports = CallcentersModel.extend({
    tableName: "callcenters"
});