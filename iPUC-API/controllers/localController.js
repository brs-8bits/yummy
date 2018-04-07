'use strict';

var localController = {};

var mysql           = require('mysql');
var Locais           = require('../models/locais_mysql.js');
var config          = require('../config/config.json');

localController.getId = function (req, res, next) {
    var local = new Locais();

    local.find('first', {where: 'ID = '+ req.params.id}, function (err, rows, fields) {
            if (err) return next(err);
            res.json(rows);
    });
};

localController.get = function (req, res, next) {
    var local = new Locais();

    local.find('all', {group: ['ID'], groupDESC:true}, function (err, rows, fields) {
        if (err) return next(err);
        res.json(rows);
    });

    // local.query('SELECT * FROM local as LEFT JOIN likes ON L.ID = likes.LOCAL_ID;', function (err, rows, fields) {
    //         if (err) return next(err);
    //         res.json(rows);
    //     });

};

<<<<<<< HEAD
//Registrar
localController.post = function (req, res, next) {
    var localNovo = {
        URL_IMAGEM : req.body.URL_IMAGEM,
        DESCRICAO : req.body.DESCRICAO,
        CIDADE : req.body.CIDADE,
        CATEGORIA_PEIXES : req.body.CATEGORIA_PEIXES,
        CATEGORIA : req.body.CATEGORIA,
        LATITUDE : req.body.LATITUDE,
        LONGITUDE : req.body.LONGITUDE,
        ESTADO : req.body.ESTADO,
        CONTATO : req.body.CONTATO,
        SERVICOS : req.body.SERVICOS
    };
    var local = new Locais(localNovo);

    console.log(local);

    local.save(function (error, result, fields) {
        if (error) return next(error);
        res.json(result);
    });
};

module.exports = localController;
=======
module.exports = localController;
>>>>>>> ecf3e1b5b2a0126236444a86b204ccbfe1ec99f1
