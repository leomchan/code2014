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
			var oldValue = countries[country].Value;
			countries[country].GoodsValue = oldValue + value;


		}
		else {
			var englishName = result.get("Country_Name_Eng");
			var frenchName = result.get("Country_Name_Fre");
			countries[country] = {"country":country, "englishName":englishName, "frenchName":frenchName, "GoodsValue":value, "FinancialAmount":0};

		}

	},
	{
		success: function() {
			console.log(countries);


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
			var oldValue = countries[country].Value;
			countries[country].GoodsValue = oldValue + value;


		}
		else {
			var englishName = result.get("Country_Name_Eng");
			var frenchName = result.get("Country_Name_Fre");
			countries[country] = {"country":country, "englishName":englishName, "frenchName":frenchName, "GoodsValue":0, "FinancialAmount":amount};

		}

	},
	{
		success: function() {
			console.log(countries);


		},
		error: function (error) {
			console.log ("Something broke");
			console.log (error);

		}

	});

