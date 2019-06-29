chrome.runtime.onMessage.addListener(function(msg, sender, sendResponse) {

  chrome.tabs.query({active:true, windowType:"normal", currentWindow: true},function(d){
    var tabId = d[0].id;
    if (msg.icon) {
      chrome.browserAction.setIcon({ path: `icons/${msg.icon}.png`, tabId: tabId });
    }
    if (msg.message) {
      chrome.browserAction.setTitle({ title: msg.message, tabId: tabId });
    }
  });
});

