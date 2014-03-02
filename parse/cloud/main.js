Parse.Cloud.job("determineTrending", function (request, status) {
	var query = new Parse.Query('CountryInfo');
	query.limit(1000);
	query.find()
	.then(function (infos) {
		// Get trends from google
		return Parse.Cloud.httpRequest({
			url: "http://www.google.com/trends/hottrends/atom/hourly"
		})
		.then(function (response) {
			var text = response.text.toLowerCase();
			var trends = [];
			var itemIndex = text.indexOf("<li>");
			while (itemIndex >= 0) {
				// Find end of item
				var endIndex = text.indexOf("</a>", itemIndex);
				var startIndex = text.lastIndexOf(">", endIndex) + 1;
				trends.push(text.substring(startIndex, endIndex).trim());
				itemIndex = text.indexOf("<li>", endIndex);
			}

			function checkCountryInTrends(remainingInfos) {
				if (remainingInfos.length > 0) {
					var info = remainingInfos[0];
					var inTrends = false;
					var countryName = info.get("englishName").trim().toLowerCase();
					trends.forEach(function (trend) {
						if (countryName.indexOf(trend) >= 0) {
							inTrends = true;
							return false;
						}
						else {
							return true;
						}
					});

					info.set("trending", inTrends);
					return info.save()
					.then(function () {
						return checkCountryInTrends(remainingInfos.slice(1));
					});
				}
				else {
					return Parse.Promise.as(true);
				}
			}

			return checkCountryInTrends(infos.slice());
		});

	})
	.then(function () {
		status.success();
	}, function (error) {
		status.error(error);
	});
});
