var setup = require('./setup.js');
var config = setup.setup();
var Parse = config.Parse;


var countryInfo = Parse.Object.extend("CountryInfo");

var countryInfoQuery = new Parse.Query(countryInfo);
countryInfoQuery.descending ("numContributors");
countryInfoQuery.limit(1000);
countryInfoQuery.find (
	function (result) {


		for (var i=0; i< result.length; i++) {
			console.log(result[i].get("countryCode") + result[i].get("totalContributions"));
			result[i].set("numbercontributorsRank", i+1);
			result[i].save(null, {
				success: function (countryInfoObject) {
				//console.log('New object created with objectId ' + countryInfoObject.id);

				},
				error: function (countryInfoObject, error) {
				console.log ('Failed to create new object: ' + error.description)
				}
			})
		}

	},
	{
		success: function() {
			console.log("Done");

		},
		error: function (error) {
			console.log("error: " + error.description);
		}
	});