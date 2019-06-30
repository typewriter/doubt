function generateUuid() {
  // https://github.com/GoogleChrome/chrome-platform-analytics/blob/master/src/internal/identifier.js
  // const FORMAT: string = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx";
  let chars = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".split("");
  for (let i = 0, len = chars.length; i < len; i++) {
    switch (chars[i]) {
      case "x":
        chars[i] = Math.floor(Math.random() * 16).toString(16);
        break;
      case "y":
        chars[i] = (Math.floor(Math.random() * 4) + 8).toString(16);
        break;
    }
  }
  return chars.join("");
}

function save_options(server, key) {
  chrome.storage.sync.set({
    server: server,
    key: key
  }, function() {});
}

function restore_options(fn) {
  chrome.storage.sync.get({
    server: null,
    key: null
  }, function(items) {
    let server = items.server;
    let key = items.key;
    if (items.server == null) {
      server = 'https://shika.nyamikan.net/doubt'
      key = generateUuid();
      save_options(server, key);
    }
    fn(server, key);
  });
}

