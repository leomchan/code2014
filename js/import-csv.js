var setup = require('./setup.js');
var config = setup.setup();
var Parse = config.Parse;
var tilde = require('tilde-expansion');

console.log(process.argv[2]);