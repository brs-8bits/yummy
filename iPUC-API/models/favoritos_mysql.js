var config = require('../config/config.json');
var mysqlModel = require('mysql-model');

var FavoritosModel = mysqlModel.createConnection(config.db);

module.exports = FavoritosModel.extend({
    tableName: "favorito"
});