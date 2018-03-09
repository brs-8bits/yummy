'use strict';

var userController = {};

var mysql           = require('mysql');
var Users           = require('../models/users_mysql.js');
var md5             = require('md5');
var jsonwebtoken    = require('jsonwebtoken');
var config          = require('../config/config.json');

userController.get = function (req, res, next) {
    var users = new Users();
    users.find('first', {where: 'id = '+ req.params.id}, function(err, rows, fields) {
        if (err) return next(err);
        res.json(rows);
    });
};

userController.post = function (req, res, next) {
    var users = new Users();

    users.id = req.body.id;
    users.password = md5(req.body.password);


    var token = jsonwebtoken.sign(users, config.jwt_secret);
    users.save();
    users.find('first', {where: 'id = '+ req.params.id}, function(err, rows, fields) {
        if (err) return next(err);

        res.header.authorization = token;
        res.json(rows);
    });
};



module.exports = userController;