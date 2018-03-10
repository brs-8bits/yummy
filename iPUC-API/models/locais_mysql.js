
var config = require('../config/config.json');
var mysqlModel = require('mysql-model');

var LocalModel = mysqlModel.createConnection(config.db);

module.exports = LocalModel.extend({
    tableName: "local"
});