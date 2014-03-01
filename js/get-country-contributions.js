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
			var oldValue = countries[country].GoodsValue;
			countries[country].GoodsValue = oldValue + value;


		}
		else {
			var englishName = result.get("Country_Name_Eng");
			var frenchName = result.get("Country_Name_Fre");
			countries[country] = {"country":country, "englishName":englishName, "frenchName":frenchName, "goodsValue":value, "financialAmount":0};

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
			var oldAmount = countries[country].FinancialAmount;
			countries[country].FinancialAmount = oldAmount + amount;


		}
		else {
			var englishName = result.get("Country_Name_Eng");
			var frenchName = result.get("Country_Name_Fre");
			countries[country] = {"country":country, "englishName":englishName, "frenchName":frenchName, "goodsValue":0, "financialAmount":amount};

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

