'use strict';

var callsController = require('../controllers/callsController');

module.exports = function (app) {
    app.post('/calls/user', callsController.user);
    app.post('/calls/callcenter', callsController.callcenter);
    app.get('/calls/:id', callsController.get);
    app.put('/calls/:id', callsController.put);
};