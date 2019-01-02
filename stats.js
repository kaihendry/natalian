function trackError (e) {
  console.log('Error detected')
  console.debug(e)
  console.log('Path', e.path)
  console.log('Line number', e.lineNumber)
}

// Triggering an error in the console:
// You have to use something like setTimeout(function() { notThere(); }, 0);
window.addEventListener('error', trackError, true)

const greet = function () {
  var hours = new Date().getHours()
  if (hours < 12) { return 'Good Morning!' } else if (hours < 18) { return 'Good Afternoon!' } else { return 'Good Evening!' }
}

var g = document.getElementById('greet')
if (g) { g.innerHTML = greet() }
