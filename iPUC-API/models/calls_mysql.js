
var config = require('../config/config.json');
var mysqlModel = require('mysql-model');

var CallModel = mysqlModel.createConnection(config.db);

module.exports = CallModel.extend({
    tableName: "calls"
});

