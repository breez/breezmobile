function interceptClickEvent(e) {
    console.log("interceptClickEvent " + e);
    var href;
    var target = e.target || e.srcElement;    
    if (target && target.parentElement) {
        var div = target.parentElement;
        var url = div.getAttribute("value");
        if (url && url.toLowerCase().startsWith("lightning:")) {
            window.postMessage(JSON.stringify({"lightningLink": url}), "*");
        }
    }
    if (target.tagName === 'A') {
        href = target.getAttribute('href');
    } else if (target.tagName === 'svg' && target.parentElement && target.parentElement.tagName === 'A') {
        href = target.parentElement.getAttribute('href');
    } else if (target.tagName === 'rect' && target.parentElement && target.parentElement.tagName === 'svg' && target.parentElement.parentElement && target.parentElement.parentElement.tagName === 'A') {
        href = target.parentElement.parentElement.getAttribute('href');
    }
    console.log("interceptClickEvent href=" + href);
    if (href && href.startsWith("lightning:")) {
        window.postMessage(JSON.stringify({"lightningLink": href}), "*");
    }
}


//listen for link click events at the document level
if (document.addEventListener) {
    document.addEventListener('click', interceptClickEvent);
} else if (document.attachEvent) {
    document.attachEvent('onclick', interceptClickEvent);
}