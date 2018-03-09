'use strict';

var userController = require('../controllers/userController');
var jwt            = require('../controllers/jwt.js');

module.exports = function (app) {

    // Authorization validate user
    app.use('/user/:id', function (req, res, next) {
        jwt(req, res, next)
    });

    app.get('/user/:id', userController.get);
    app.post('/user', userController.post);
    // app.put('/user/:id', userController.get);
};