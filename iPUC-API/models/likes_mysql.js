var config = require('../config/config.json');
var mysqlModel = require('mysql-model');

var DicasModel = mysqlModel.createConnection(config.db);

module.exports = DicasModel.extend({
    tableName: "likes"
});