
var config = require('../config/config.json');
var mysqlModel = require('mysql-model');

var UsersModel = mysqlModel.createConnection(config.db);

module.exports = UsersModel.extend({
    tableName: "users"
});