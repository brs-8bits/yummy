'use strict';

var userController = require('../controllers/userController');
var localController = require('../controllers/localController');
var dicaController = require('../controllers/dicaController');
var jwt            = require('../controllers/jwt.js');

module.exports = function (app) {

    // Authorization validate user
    app.use('/user/:id', function (req, res, next) {
        jwt(req, res, next)
    });
    app.get('/user/:id', userController.get);
    app.post('/signup', userController.signup);
    app.post('/signin', userController.signin);

    app.get('/local', localController.get);
    app.get('/local/:id', localController.get);

    app.get('/dica/:id', dicaController.get);
    app.post('/dica', dicaController.post);
};