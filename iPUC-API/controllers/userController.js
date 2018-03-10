'use strict';

var userController = {};

var mysql           = require('mysql');
var Users           = require('../models/users_mysql.js');
var md5             = require('md5');
var jsonwebtoken    = require('jsonwebtoken');
var config          = require('../config/config.json');

userController.get = function (req, res, next) {
    var user = new Users();
    user.find('first', {where: 'ID = '+ req.params.id}, function(err, rows, fields) {
        if (err) return next(err);
        res.json(rows);
    });
};

userController.post = function (req, res, next) {
    var addUser = {
        EMAIL : req.body.EMAIL,
        SENHA : md5(req.body.SENHA)

    };
    var user = new Users(addUser);

    console.log(user)

    user.save(function (error, result, fields) {
        if (error) return next(error);

        user.find('first', {where: 'ID = '+ result.insertId}, function(error, result, fields) {
            if (error) return next(error);
            var token = 'Baerer ' + jsonwebtoken.sign(result, config.jwt_secret);
            res.header('authorization', [token])
            res.json(result);
        });
    });
};



// function getUser( ) {
//
// };


module.exports = userController;