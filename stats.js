(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-195686-1', 'auto');
ga('send', 'pageview');

// Trigger like so
function trackJavaScriptError(e) {
	console.debug(e);
	var ie = window.event || {};
	errMsg = e.message || ie.errorMessage || "404 errror on " + window.location;
	var errSrc = (e.filename || ie.errorUrl) + ': ' + (e.lineno || ie.errorLine);
	ga('send', 'event', 'Error', errMsg, errSrc, { 'nonInteraction': 1 });
}

window.addEventListener('error', trackJavaScriptError, true);

greet = function() {
	var now = new Date();
	var hours = now.getHours();
	if (hours >= 18)
		return "Good Evening!";
	else if (hours >= 12)
		return "Good Afternoon!";
	else
		return "Good Morning!";
};


document.addEventListener("DOMContentLoaded", function() {
	var g = document.getElementById("greet");
	g.innerHTML = greet();
});
