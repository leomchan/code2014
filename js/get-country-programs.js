var setup = require('./setup.js');
var config = setup.setup();
var Parse = config.Parse;

//get the countries where programs exist

//var CountryInfoObject = new Parse.
var totalCount = 0;
var countries = Object.create(null);
var Country = Parse.Object.extend("Country");
var countryInfoQuery = new Parse.Query(Country);
countryInfoQuery.each (
	function (result) {

		var country = result.get("Country");
		var charityID = result.get("BN");
		if (country == undefined)
			return;

		var countryObject = null;
		if (country in countries) {
			//add the value to ehre
			countryObject = countries[country];
			//countries[country].numPrograms++;

		}
		else {
			countries[country] = {"country":country, "numPrograms":0, "contributors":{}};
			countryObject = countries[country];

		}

		if (charityID in countries[country].contributors) {
		}
		else {
			countryObject.numPrograms++;
			countryObject.contributors[charityID] = {"BN":charityID};

		}
		totalCount++;
	},
		{
		success: function() {
			console.log(countries);
			console.log ("total records processed: " + totalCount);
			addNumberPrograms();


		},
		error: function (error) {
			console.log ("Something broke");
			console.log (error);

		}

	});


function addNumberPrograms() {
	var totalCount = 0;

	//for (var key in countries) {

		//var country = countries[key];
		//console.log(country);

		var countryInfo = Parse.Object.extend("CountryInfo")
		var countryInfoQuery = new Parse.Query(countryInfo);
		countryInfoQuery.each (
		function (result) {

		var countryCode = result.get("countryCode");
		var totalContributions = result.get("totalContributions");

		// console.log("country code"  +countryCode);
		// console.log ("total contributions: " + totalContributions);
		var countryObject = countries[countryCode];

		if (countryObject == undefined)
			return;
		console.log(countryCode);
		console.log("Country object: " + countryObject);
		result.set("numPrograms", countryObject.numPrograms);
		result.save(null, {
			success: function (countryInfoObject) {
				//console.log('New object created with objectId ' + countryInfoObject.id);

			},
			error: function (countryInfoObject, error) {
				console.log ('Failed to create new object: ' + error.description)
			}
		})
	}, 
	{
		success: function() {
			console.log("lala");

		},
		error: function(error) {

		}
	});
		/*
		var countryInfoQuery = new Parse.Query("CountryInfo");
		var CountryInfoObject = Parse.Object.extend("CountryInfo");
		var countryInfoObject = new CountryInfoObject();
		countryInfoQuery.equalTo("countryCode", country.country);
		countryInfoQuery.find({
			success: function (results) {


				console.log(key);
				console.log ("Country: " + country.country);
				console.log("numProgras: " + country.numPrograms);
				countryInfoObject.set("numPrograms", country.numPrograms);
				/*countryInfoObject.save(null, {
					success: function (countryInfoObject) {
				//console.log('New object created with objectId ' + countryInfoObject.id);

				},
				error: function (countryInfoObject, error) {
					console.log ('Failed to create new object: ' + error.description)
				}
		}) */

			/*
			}, 
			error: function (error) {

			}
		});
*/

			
		totalCount++;
	
	console.log("total " + totalCount);
}


