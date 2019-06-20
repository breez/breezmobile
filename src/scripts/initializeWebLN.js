var requestId = 0;
var requestCallbacks = {}

function invokeWeblnAction(actionData){
    var newReqID = requestId++;
    actionData['requestId'] = newReqID;
    //console.error('invoking webln action ' + actionData.action + " " + JSON.stringify(actionData));    
    window.postMessage(JSON.stringify(actionData), "*");
    return new Promise(function (resolve, reject) {
        requestCallbacks[newReqID] = {resolve: resolve, reject: reject};                
    });
}

webln = {
    enable: function () {
        return invokeWeblnAction({ action: 'enable', enable: true });        
    },
    sendPayment: function (paymentRequest) {
        return invokeWeblnAction({ action: 'sendPayment', payReq: paymentRequest});        
    },
    getInfo: function () {
        return invokeWeblnAction({ action: 'getInfo'});        
    },
    makeInvoice: function (invoiceArgs) {
        return invokeWeblnAction({ action: 'makeInvoice', invoiceArgs: invoiceArgs});        
    },
    signMessage: function (msg) {
        return invokeWeblnAction({ action: 'signMessage', msg: msg});        
    },
    verifyMessage: function (msg) {
        return invokeWeblnAction({ action: 'verifyMessage', msg: msg});        
    },
};

function resolveRequest(reqId, res) {
    var callbacks = requestCallbacks[reqId];
    if (callbacks && callbacks.resolve) {
        callbacks.resolve(res);
    }
    delete requestCallbacks[reqId];
}

function rejectRequest(reqId, res) {
    var callbacks = requestCallbacks[reqId];
    if (callbacks && callbacks.reject) {
        callbacks.reject(res);
    }
    delete requestCallbacks[reqId];
}