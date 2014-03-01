var setup = require('./setup.js');
var config = setup.setup();
var Parse = config.Parse;
var fs = require('fs');
var tilde = require('tilde-expansion');
var csv = require('csv');
var path = require('path');
var q = require('q');

var csvPath = process.argv[2];


tilde(csvPath, function (s) {
	csvPath = s;
});

var className = path.basename(csvPath);
var firstDot = className.indexOf('.');
if (firstDot >= 0) {
	className = className.substring(0, className.indexOf('.'));	
}

className = className.substring(0, 1).toUpperCase() + className.substring(1);

className = className.replace(/[^a-zA-Z0-9]/g,'_');
className = className.replace(/_+/g,'_');
className = className.replace(/^_+/g, '');
className = className.replace(/_+$/g, '');

console.log("Class Name:" + className);

function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}

var ClassObject = Parse.Object.extend(className);

function skipAndAddObjects(offset) {
	var fields = [];
	var objectsToAdd = [];
	var deferred = q.defer();
	var skipped = 0;

	csv()
	.from.stream(fs.createReadStream(csvPath))
	.on('record', function (row, index) {
		if (index === 0) {
			fields = row;
			for (var i = 0; i < fields.length; i++) {
				fields[i] = fields[i].trim();

				// Remove anything that is not a digit or letter
				fields[i] = fields[i].replace(/[^a-zA-Z0-9]/g,'_');
				fields[i] = fields[i].replace(/_+/g,'_');
				fields[i] = fields[i].replace(/^_+/g, '');
				fields[i] = fields[i].replace(/_+$/g, '');

				if (fields[i].length === 0) {
					fields[i] = 'f_' + i;
				}

				if (isNumber(fields[i].substring(0,1))) {
					fields[i] = 'f' + fields[i];
				}
			}
		}
		else {
			if (offset === skipped) {
				if (objectsToAdd.length < 1000) {
					var parseObject = new ClassObject();
					var modified = false;

					for (var j = 0; j < row.length; j++) {
						var value = row[j];
						if (value) {
							parseObject.set(fields[j], value);
							modified = true;
						}
					}

					if (modified) {
						objectsToAdd.push(parseObject);
					}					
				}
			}
			else {
				skipped++;
			}
		}
	})
	.on('end', function (count) {
		var nextOffset = offset + objectsToAdd.length;
		console.log("Adding " + offset + "…" + nextOffset);

		Parse.Object.saveAll(objectsToAdd)
		.then(function () {
			if (nextOffset < (count - 1)) {
				skipAndAddObjects(nextOffset)
				.then(function () {
					deferred.resolve(nextOffset);
				}, function (err) {
					deferred.reject(err);
				});
			}
			else {
				deferred.resolve(nextOffset);
			}

		}, function (err) {
			deferred.reject(err);
		});
	});

	return deferred.promise;
}

skipAndAddObjects(0)
.then(function (count) {
	console.log('Added ' + count + ' records.');
	process.exit(0);
}, function (err) {
	console.error(err);
	process.exit(1);
});
