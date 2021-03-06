var setup = require('./setup.js');
var config = setup.setup();
var Parse = config.Parse;
var tilde = require('tilde-expansion');
var fs = require('fs');
var csv = require('csv');

var csvPath = process.argv[2];

tilde(csvPath, function (s) {
	csvPath = s;
});

csv()
.from.stream(fs.createReadStream(csvPath))
.to.array(function (rows) {
	function addGeoPointToCountryInfo(remainingRows) {
		if (remainingRows.length > 0) {
			var row = remainingRows[0];
			var countryQuery = new Parse.Query('CountryInfo');
			countryQuery.equalTo("countryCode", row[0]);
			return countryQuery.first()
			.then(function (info) {
				if (info) {
					var latitude = parseFloat(row[3]);
					var longitude = parseFloat(row[2]);
					var location = new Parse.GeoPoint(latitude, longitude);
					info.set("location", location);
					return info.save();
				}
				else {
					return Parse.Promise.as(true);
				}
			})
			.then(function () {
				return addGeoPointToCountryInfo(remainingRows.slice(1));
			});
		}
		else {
			return Parse.Promise.as(true);
		}
	}

	addGeoPointToCountryInfo(rows.slice(1))
	.then(function () {
		console.log("Done.");
		process.exit(0);
	}, function (err) {
		console.error(err);
		process.exit(1);
	});
});