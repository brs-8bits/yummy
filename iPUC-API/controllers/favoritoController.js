'use strict';

var favoritoController = {};

var mysql           = require('mysql');
var Favoritos       = require('../models/favoritos_mysql.js');
var config          = require('../config/config.json');
var jsonwebtoken    = require('jsonwebtoken');

favoritoController.post = function (req, res, next) {

    var token = req.headers.authorization;
    token = token.split(' ');

    var user = jsonwebtoken.decode(token[1]);

    var addFavorito = {
        LOCAL_ID: req.params.id,
        PERFIL_ID: user.ID
    };
    console.log(addFavorito);
    var favorito = new Favoritos(addFavorito);

    favorito.find('first',{where: "LOCAL_ID = '"+ req.params.id +"' AND PERFIL_ID = '"+ user.ID +"'"}, function (err, rows, fields) {
        if (err) return next(err);
        console.log(err)
        if(rows != undefined){
            favorito.remove('ID = ' + rows.ID,function (error, result, fields) {
                if (error) return next(error);
                res.json(result);
            });
        }else{
            favorito.save(function (error, result, fields) {
                if (error) return next(error);
                res.json(result);
            });
        }
    });
};

favoritoController.get = function (req, res, next) {
    var favorito = new Favoritos();

    favorito.find('all', function (err, rows, fields) {
        if (err) return next(err);
        res.json(rows);
    });
};

module.exports = favoritoController;