'use strict';

var likeController = {};

var mysql           = require('mysql');
var Likes           = require('../models/likes_mysql.js');
var config          = require('../config/config.json');
var jsonwebtoken    = require('jsonwebtoken');

likeController.post = function (req, res, next) {

    var token = req.headers.authorization;
    token = token.split(' ');

    var user = jsonwebtoken.decode(token[1]);

    var addLike = {
        LOCAL_ID: req.params.id,
        PERFIL_ID: user.ID
    };
    console.log(user);
    var likes = new Likes(addLike);

    likes.find('first',{where: "LOCAL_ID = '"+ req.params.id +"' AND PERFIL_ID = '"+ user.ID +"'"}, function (err, rows, fields) {
        if (err) return next(err);
        console.log(rows)
        if(rows != undefined){
            likes.remove('ID = ' + rows.ID,function (error, result, fields) {
                if (error) return next(error);
                res.json(result);
            });
        }else{
            likes.save(function (error, result, fields) {
                if (error) return next(error);
                res.json(result);
            });
        }
    });
};

likeController.get = function (req, res, next) {
    var likes = new Likes();

    likes.find('all', function (err, rows, fields) {
        if (err) return next(err);
        res.json(rows);
    });
};

module.exports = likeController;