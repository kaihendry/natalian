function trackError(e) {
	var ie = window.event || {};
	errMsg = e.message || ie.errorMessage || "404 errror on " + window.location;
	var errSrc = (e.filename || ie.errorUrl) + ': ' + (e.lineno || ie.errorLine);
	console.log('send', 'event', 'Error', errMsg, errSrc, { 'nonInteraction': 1 });
}

// Triggering an error in the console:
// You have to use something like setTimeout(function() { notThere(); }, 0);
window.addEventListener('error', trackError, true);

greet = function() {
	var hours = new Date().getHours();
	if (hours < 12)
		return "Good Morning!";
	else if (hours < 18)
		return "Good Afternoon!";
	else
		return "Good Evening!";
};


var g = document.getElementById("greet");
if (g) {
	g.innerHTML = greet();
}
