'use strict';

var dicaController = {};

var mysql           = require('mysql');
var Dicas           = require('../models/dicas_mysql.js');
var jsonwebtoken    = require('jsonwebtoken');
var config          = require('../config/config.json');

dicaController.get = function (req, res, next) {
    var dica = new Dicas();

    if(req.params.id) {
        dica.find('first', {where: 'ID = ' + req.params.id}, function (err, rows, fields) {
            if (err) return next(err);
            res.json(rows);
        });
    }else{
        dica.find('all', function (err, rows, fields) {
            if (err) return next(err);
            res.json(rows);
        });
    }
};

//Registrar
dicaController.post = function (req, res, next) {
    var dicaUser = {
        CATEGORIA : req.body.CATEGORIA,
        TITULO : req.body.TITULO,
        URL_IMAGEM : req.body.URL_IMAGEM,
        DESCRICAO : req.body.DESCRICAO,
        COMENTARIO : req.body.COMENTARIO,
        PERFIL_ID : req.body.PERFIL_ID
    };
    var dica = new Dicas(dicaUser);

    console.log(dica);

    dica.save(function (error, result, fields) {
        if (error) return next(error);
        res.json(result);
    });
};

dicaController.put = function (req, res, next) {
    var dicaUser = {
        CATEGORIA : req.body.CATEGORIA,
        TITULO : req.body.TITULO,
        URL_IMAGEM : req.body.URL_IMAGEM,
        DESCRICAO : req.body.DESCRICAO,
        COMENTARIO : req.body.COMENTARIO,
        PERFIL_ID : req.body.PERFIL_ID
        // ID : req.params.id
    };
    var dica = new Dicas(dicaUser);

    console.log(dica);
    dica.save('ID= ' + req.params.id, function (error, result, fields) {
        if (error) return next(error);
        res.json(result);
    });
};

dicaController.delete = function (req, res, next) {
    var dica = new Dicas();

    dica.remove('ID = ' + req.params.id,function (error, result, fields) {
        if (error) return next(error);
        res.json(result);
    });
};


module.exports = dicaController;