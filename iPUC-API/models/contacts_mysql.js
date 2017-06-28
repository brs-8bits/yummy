
var config = require('../config/config.json');
var mysqlModel = require('mysql-model');

var ContactsModel = mysqlModel.createConnection(config.db);

module.exports = ContactsModel.extend({
    tableName: "contacts"
});