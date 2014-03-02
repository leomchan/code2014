var setup = require('./setup.js');
var config = setup.setup();
var Parse = config.Parse;



var countryInfo = Parse.Object.extend("CountryInfo");
var totalAmount = 874381363 //hard coded
var numCountries = 119;
var mean = totalAmount/numCountries;
var variance = 0;

var countryInfoQuery = new Parse.Query(countryInfo);
countryInfoQuery.each (
	function (result) {
		var totalContributions = result.get("totalContributions");

		var diff = totalContributions - mean;
		variance = variance + diff * diff;



	}, 
	{
		success: function() {
			variance = variance / numCountries;
			var stddev = Math.sqrt(variance);

			console.log("Mean is: " + mean);
			console.log("Standard deviation is: " + stddev);

		},
		error: function(error) {

		}
	});
