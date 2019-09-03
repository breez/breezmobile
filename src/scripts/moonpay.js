function getParameterByName(name) {
    name = name.replace(/[\\[\\]]/g, '\\\\\$&');
    var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|\$)'),
        results = regex.exec(window.location.href);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\\+/g, ' '));
}

var alertInterval = setInterval(function () {
    if (document.URL.indexOf("https://buy.moonpay.io/transaction_receipt?addFunds=true") >= 0 && getParameterByName('transactionId') != null && getParameterByName('addFunds') == 'true') {
        window.postMessage(JSON.stringify({ status: 'completed' }), "*");
        clearInterval(alertInterval);
    }
}, 50);