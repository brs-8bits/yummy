'use strict';

var localController = {};

var mysql           = require('mysql');
var Locais           = require('../models/locais_mysql.js');
var config          = require('../config/config.json');

localController.get = function (req, res, next) {
    var local = new Locais();

    local.find('first', {where: 'ID = '+ req.params.id}, function (err, rows, fields) {
            if (err) return next(err);
            res.json(rows);
    });
};

localController.get = function (req, res, next) {
    var local = new Locais();

    local.find('all', function (err, rows, fields) {
        if (err) return next(err);
        res.json(rows);
    });
};

module.exports = localController;