var setup = require('./setup.js');
var config = setup.setup();
var Parse = config.Parse;

console.log ("hi");
var countries = Object.create (null);



var exportedGoods = Parse.Object.extend("Sch2g");

var exportedGoodsQuery = new Parse.Query(exportedGoods);
exportedGoodsQuery.each (
	function (result) {
		var country = result.get("Country");
		var value = result.get("Value");
		if (value == undefined)
			return;
		value = parseFloat(value);


		if (country == undefined)
			return; //ignore these
		/*
		if (value == NaN) {
			console.log (country + " has undefined value, currently " + countries[country].Value);			
		}*/
		
		//console.log(country);
		//console.log("Value: " + value);

		if (country in countries) {
			//add the value to ehre
			var oldValue = countries[country].goodsValue;
			countries[country].goodsValue = oldValue + value;


		}
		else {
			var englishName = result.get("Country_Name_Eng");
			var frenchName = result.get("Country_Name_Fre");
			countries[country] = {"country":country, "englishName":englishName, "frenchName":frenchName, 
				"goodsValue":value, "financialAmount":0, "numContributors":0, "contributors":{}};

		}
		var charityID = result.get("BN");
		if (charityID in countries[country].contributors) {
		}
		else {
			countries[country].numContributors++;
			countries[country].contributors[charityID] = {"BN":charityID};

		}


	},
	{
		success: function() {
			//console.log(countries);


		},
		error: function (error) {
			console.log ("Something broke");
			console.log (error);

		}

	});


var financialResources = Parse.Object.extend("Sch2r")

var financialResourcesQuery = new Parse.Query(financialResources);

financialResourcesQuery.each (
	function (result) {
		var country = result.get("Country");
		var amount = result.get("Amount");
		if (amount == undefined)
			return;
		amount = parseFloat(amount);


		if (country == undefined)
			return; //ignore these
		/*
		if (value == NaN) {
			console.log (country + " has undefined value, currently " + countries[country].Value);			
		}*/
		
		//console.log(country);
		//console.log("Value: " + value);

		if (country in countries) {
			//add the value to ehre
			var oldAmount = countries[country].financialAmount;
			countries[country].financialAmount = oldAmount + amount;


		}
		else {
			var englishName = result.get("Country_Name_Eng");
			var frenchName = result.get("Country_Name_Fre");
			countries[country] = {"country":country, "englishName":englishName, 
				"frenchName":frenchName, "goodsValue":0, "financialAmount":amount, "numContributors":0, "contributors":{}};

		}

		var charityID = result.get("BN");
		if (charityID in countries[country].contributors) {

		}
		else {
			countries[country].numContributors++;
			countries[country].contributors[charityID] = {"BN":charityID};

		}

	},
	{
		success: function() {
			console.log(countries);
			addCountryInfo();


		},
		error: function (error) {
			console.log ("Something broke");
			console.log (error);

		}

	});

var CountryInfo = Parse.Object.extend("CountryInfo");

//var countryInfo = new CountryInfo;
function addCountryInfo() {

	//do some post iterative processing for stats...

	//var sortable = [];
	var totalContributionsToAllCountries = 0;
	for (var key in countries) {
		var country = countries[key];
		country.totalContributions = country.financialAmount + country.goodsValue;

		totalContributionsToAllCountries += country.totalContributions;

		//sortable.push([])

	}

	console.log ("the total amount of contributions to all countries is: " + totalContributionsToAllCountries);
	var percentageSum = 0;
	for (var key in countries) {
//		if (countries.hasOwnProperty(key)) {
//			continue;
//		}
		var country = countries[key];
		console.log (country);
		var countryInfoObject = new CountryInfo();
		countryInfoObject.set("countryCode", country.country);
		countryInfoObject.set("englishName", country.englishName);
		countryInfoObject.set("frenchName", country.frenchName);
		countryInfoObject.set("goodsValue", country.goodsValue);
		countryInfoObject.set("financialAmount", country.financialAmount);
		countryInfoObject.set("numContributors",country.numContributors);
		countryInfoObject.set("totalContributions", country.totalContributions);
		//countyrInfoObject.set("rankInDollars", );
		//countryInfoObject.set("rankinNumContributors")
		var percentageFunds = country.totalContributions / totalContributionsToAllCountries;
		countryInfoObject.set("percentageFunds", percentageFunds);
		percentageSum+=percentageFunds;


		countryInfoObject.save(null, {
			success: function (countryInfoObject) {
				//console.log('New object created with objectId ' + countryInfoObject.id);

			},
			error: function (countryInfoObject, error) {
				console.log ('Failed to create new object: ' + error.description)
			}
		})
	}
	console.log("Percentage sum: " + percentageSum);


}
