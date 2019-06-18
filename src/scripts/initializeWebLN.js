var requestId = 0;
var pendingPromise = null;

webln = {
    enable: function () {
        window.postMessage(JSON.stringify({ enable: true }), "*");
        return new Promise(function (resolve, reject) { resolve(true); });
    },
    sendPayment: function (paymentRequest) {
        if ((pendingPromise == null || pendingPromise != requestId)) {
            window.postMessage(JSON.stringify({ pay_req: paymentRequest, req_id: requestId }), "*");
            pendingPromise == requestId;
            return new Promise(function (resolve, reject) {
                window.addEventListener(requestId, (event) => {
                    if (event.detail) {
                        resolve();
                        console.log("resolved");
                    } else {
                        reject(new Error('Request cancelled'));
                        console.log("rejected");
                    }
                });
            });
        }
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

function resolveRequest(reqId, res) {
    window.dispatchEvent(new CustomEvent(reqId, { detail: res }));
    requestId++;
    pendingPromise = null;
}