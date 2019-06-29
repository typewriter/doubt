const obj = { key: 'TEST', url: window.location.href };
const method = "POST";
const body = Object.keys(obj).map((key)=>key+"="+encodeURIComponent(obj[key])).join("&");
const headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
};
fetch("https://shika.nyamikan.net/classify", {method, headers, body}).then((res)=> res.json())
  .then(json => {
    if (json['Like'] > json['Dislike']) {
      chrome.runtime.sendMessage({ icon: 'icon-like' });
    } else {
      chrome.runtime.sendMessage({ icon: 'icon-dislike' });
    }
    chrome.runtime.sendMessage({ title: `Like: ${Math.round(json['Like'])}\nDislike: ${Math.round(json['Dislike'])}` });
  })
  .catch(e => {
    chrome.runtime.sendMessage({ icon: 'icon' });
    chrome.runtime.sendMessage({ title: 'Failed to load resource' });
  });

