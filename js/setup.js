module.exports.setup = function () {
	var Parse = require('parse').Parse;
	Parse.initialize("pkbkdUru3c58aGvO3PO7E3yhvqdt4qylAQZ3qsHE", "tIkW07WUbHgs1wsKogs6pbwhZD18xlZNO7HzefT7");

	return {Parse: Parse};
};