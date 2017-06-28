'use strict';

var mongoose = require('mongoose');
var Schema = mongoose.Schema;
 
var CallsSchema = new Schema({
    caller_id: {
        type: Number,
        required: '{PATH} is required!'
    },
    called_id: {
        type: Number
    },
    call_data: {
        type: String,
        required: '{PATH} is required!'
    },
    call_type: {
        type: String,
        required: '{PATH} is required!',
        enum: ['PRIVATE', 'CALLCENTER']
    },
    created_at: {
        type: Date,
        default: Date.now
    },
    updated_at: {
        type: Date,
        default: Date.now
    },
    accepted_at: {
        type: Date,
        default: Date.now
    },
    status: {
        type: String,
        enum: ['IN_PULSE', 'BUSY', 'FINALIZED', 'MISSED', 'NOT_ACCEPTED', 'TRANSFERRED', 'ACCEPTED'],
        default: 'IN_PULSE'
    }
});

/**
 * Add toJSON option to transform document before returnig the result
 */
CallsSchema.options.toJSON = {
  transform: function (doc, ret, options) {
    ret.id = ret._id;
    delete ret._id;
    delete ret.__v;
  }
};
 
module.exports = mongoose.model('Calls', CallsSchema);