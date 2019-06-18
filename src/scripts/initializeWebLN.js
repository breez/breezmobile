var processedInvoices = [];

webln = {
    enable: function () {
        window.postMessage(JSON.stringify({ enable: true }), "*");
        return new Promise(function (resolve, reject) { resolve(true); });
    },
    sendPayment: function (paymentRequest) {
        window.postMessage(JSON.stringify({ pay_req: paymentRequest }), "*");
        processedInvoices.push(paymentRequest);
        return new Promise(function (resolve, reject) { });
    },
    getInfo: function () {
        window.postMessage('getInfo', "*");
        return new Promise(function (resolve, reject) {
            reject(new Error('not implemented'));
        });
    },
    makeInvoice: function (RequestInvoiceArgs) {
        var id = Math.random();
        window.postMessage(JSON.stringify({ makeInvoice: RequestInvoiceArgs, id: id }), "*");
        return new Promise(function (resolve, reject) {
            reject(new Error('not implemented'));
        });
    },
    signMessage: function () {
        window.postMessage('signMessage', "*");
        return new Promise(function (resolve, reject) {
            reject(new Error('not implemented'));
        });
    },
    verifyMessage: function () {
        window.postMessage('verifyMessage', "*");
        return new Promise(function (resolve, reject) {
            reject(new Error('not implemented'));
        });
    },
};