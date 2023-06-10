window.nostr = {
    _requests: {},
    _pubkey: null,
  
    async getPublicKey() {
      if (this._pubkey) return this._pubkey
      this._pubkey = await this._call('getPublicKey', {})
      return this._pubkey
    },
  
    async signEvent(event) {
      return this._call('signEvent', {event})
    },
  
    async getRelays() {
      return this._call('getRelays', {})
    },
  
    nip04: {
      async encrypt(peer, plaintext) {
        return window.nostr._call('nip04.encrypt', {peer, plaintext})
      },
  
      async decrypt(peer, ciphertext) {
        return window.nostr._call('nip04.decrypt', {peer, ciphertext})
      }
    },
  
    nip26: {
      async delegate(delegateePubkey, conditionsJson) {
        return window.nostr._call('nip26.delegate', {delegateePubkey, conditionsJson})
      }
    },
  
    _call(type, params) {
        // console.log(type , params);
      return new Promise((resolve, reject) => {
        let id = Math.random().toString().slice(4)
        this._requests[id] = {resolve, reject}
        var data =  {
            id,
            from: 'nostr',
            type,
            params
          };
        window.postMessage(JSON.stringify(data)
         ,
          '*'
        )
      })
    }
  }
  


  function resolveRequest(reqId, res) {
    // console.log("resolve " + res);
    var callbacks = window.nostr._requests[reqId];
    if (callbacks && callbacks.resolve) {
        callbacks.resolve(res);
    }
    delete window.nostr._requests[reqId];
}

function rejectRequest(reqId, res) {
  // console.log("reject " + res);
    var callbacks = window.nostr._requests[reqId];
    if (callbacks && callbacks.reject) {
        callbacks.reject(res);
    }
    delete window.nostr._requests[reqId];
}
  
