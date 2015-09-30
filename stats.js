(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-195686-1', 'auto');
ga('send', 'pageview');

function trackError(e) {
	console.debug(e);
	var ie = window.event || {};
	errMsg = e.message || ie.errorMessage || "404 errror on " + window.location;
	var errSrc = (e.filename || ie.errorUrl) + ': ' + (e.lineno || ie.errorLine);
	ga('send', 'event', 'Error', errMsg, errSrc, { 'nonInteraction': 1 });
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


document.addEventListener("DOMContentLoaded", function() {
	var g = document.getElementById("greet");
	g.innerHTML = greet();
});
