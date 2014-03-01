var setup = require('./setup.js');
var config = setup.setup();
var Parse = config.Parse;
var fs = require('fs');
var tilde = require('tilde-expansion');
var csv = require('csv');

var className = process.argv[2];
var csvPath = process.argv[3];

tilde(csvPath, function (s) {
	csvPath = s;
});

function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}

var ClassObject = Parse.Object.extend(className);

csv()
.from.stream(fs.createReadStream(csvPath))
.to.array(function (rows) {
	var fields = rows[0];

	for (var i = 0; i < fields.length; i++) {
		fields[i] = fields[i].trim();

		// Remove anything that is not a digit or letter
		fields[i] = fields[i].replace(/[^a-zA-Z0-9]/g,'_');
		fields[i] = fields[i].replace(/_+/g,'_');
		fields[i] = fields[i].replace(/^_+/g, '');
		fields[i] = fields[i].replace(/_+$/g, '');
		if (isNumber(fields[i].substring(0,1))) {
			fields[i] = 'f' + fields[i];
		}
	}

	var objectsToAdd = [];

	for (var i = 1; i < rows.length; i++) {
		var row = rows[i];
		var parseObject = new ClassObject();
		var modified = false;

		for (var j = 0; j < row.length; j++) {
			var value = row[j];
			if (value) {
				parseObject.set(fields[j], value);
				modified = true;
			}
		}

		objectsToAdd.push(parseObject);
	}

	Parse.Object.saveAll(objectsToAdd)
	.then(function () {
		console.log('Done.');
		process.exit(0);
	}, function (err) {
		console.error(err);
		process.exit(1);
	})
});
