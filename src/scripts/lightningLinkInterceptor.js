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
    // if (target.tagName === 'A') {
    //     href = target.getAttribute('href');
    //     console.log("interceptClickEvent href=" + href);
    //     if (href && href.startsWith("lightning:")) {
    //         window.postMessage(JSON.stringify({"lightningLink": href}), "*");
    //     }
    // }
}


//listen for link click events at the document level
if (document.addEventListener) {
    document.addEventListener('click', interceptClickEvent);
} else if (document.attachEvent) {
    document.attachEvent('onclick', interceptClickEvent);
}