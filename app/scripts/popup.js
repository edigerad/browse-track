(function() {
  'use strict';
  var func, p;

  console.log('\'Allo \'Allo! Popup');

  p = document.getElementById('b_text');

  chrome.browserAction.getBadgeText({}, func = function(result) {
    return p.innerHTML = result;
  });

  console.log('\'Allo \'Allo! Popup');

}).call(this);
