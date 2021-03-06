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
//Login
userController.signin = function (req, res, next) {
    // var addUser = {
    //     EMAIL : req.body.EMAIL,
    //     SENHA : md5(req.body.SENHA)
    //
    // };
    var user = new Users();
    console.log(req.body.EMAIL, req.body.SENHA);
    user.find('first', {where: "EMAIL = '"+ req.body.EMAIL+"' AND SENHA = '"+ md5(req.body.SENHA)+"'"},
        function(error, result, fields) {
            if (error) return next(error);
            // var token = 'Baerer ' + jsonwebtoken.sign(result, config.jwt_secret);
            // res.header('authorization', [token])
            res.json(result);
    });

};
//Registrar
userController.signup = function (req, res, next) {
    var addUser = {
        EMAIL : req.body.EMAIL,
        SENHA : md5(req.body.SENHA)

    };
    var user = new Users(addUser);

    console.log(user.SENHA);

    user.save(function (error, result, fields) {
        if (error) return next(error);

        user.find('first', {where: 'ID = '+ result.insertId}, function(error, result, fields) {
            if (error) return next(error);
            var token = 'Baerer ' + jsonwebtoken.sign(result, config.jwt_secret);
            // var token = jsonwebtoken.sign(result, config.jwt_secret);
            // res.header('authorization', [token])
            res.json(result);
        });
    });
};


module.exports = userController;