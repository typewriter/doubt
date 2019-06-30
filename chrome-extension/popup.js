function learn(learnClass) {
  chrome.tabs.query({active:true, windowType:"normal", currentWindow: true},function(d){
    const url = d[0].url;
    restore_options(function(server, key) {
      const obj = { key: key, url: url, class: learnClass };
      const method = "POST";
      const body = Object.keys(obj).map((key)=>key+"="+encodeURIComponent(obj[key])).join("&");
      const headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
      };
      fetch(`${server}/learn`, {method, headers, body}).then((res)=> res.json())
    });
  });
}

function hide() {
  document.getElementById('like').style.display = 'none';
  document.getElementById('dislike').style.display = 'none';
  document.getElementById('learned').style.display = 'block';
}

function like() {
  hide();
  learn('Like');
}

function dislike() {
  hide();
  learn('Dislike');
}

document.getElementById('like').addEventListener('click', like);
document.getElementById('dislike').addEventListener('click', dislike);
document.getElementById('go-to-options').addEventListener('click', function() {
  if (chrome.runtime.openOptionsPage) {
    chrome.runtime.openOptionsPage();
  } else {
    window.open(chrome.runtime.getURL('options.html'));
  }
});
