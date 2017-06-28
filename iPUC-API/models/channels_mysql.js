/**
 * Created by OzeiasFurtozo on 06/04/17.
 */

var config = require('../config/config.json');
var mysqlModel = require('mysql-model');

var ChannelsModel = mysqlModel.createConnection(config.db);

module.exports = ChannelsModel.extend({
    tableName: "callcenter_channels"
});