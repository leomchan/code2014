var setup = require('./setup.js');
var config = setup.setup();
var Parse = config.Parse;
var datejs = require('datejs');

var className = process.argv[2];
var afterDate = Date.parse(process.argv[3]);
console.log("Removing records created after " + afterDate);

function deleteObjects(deleteCount) {
	var query = new Parse.Query(className);
	query.greaterThan("createdAt", afterDate);
	query.limit(1000);
	return query.find()
	.then(function (parseObjects) {
		if (parseObjects.length > 0) {
			return Parse.Object.destroyAll(parseObjects)
			.then(function () {
				return deleteObjects(deleteCount + parseObjects.length);
			});
		}
		else {
			return Parse.Promise.as(deleteCount);
		}
	});
}

deleteObjects(0)
.then(function (count) {
	console.log("Deleted " + count + " records");
	process.exit(0);
}, function (err) {
	console.error(err);
	process.exit(1);
});
