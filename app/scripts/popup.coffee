'use strict';

console.log('\'Allo \'Allo! Popup')
p = document.getElementById 'b_text'
chrome.browserAction.getBadgeText({}, func = (result) -> p.innerHTML = result);
console.log('\'Allo \'Allo! Popup')
