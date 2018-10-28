# Breez Mobile Client

<p align='center'>
  <a href='https://breez.technology'>
    <img src='https://drive.google.com/uc?id=1MHi-sdhoOXTxnlkwa2Eg0e6LThr0r_x-&export=download' height='400' alt='screenshot' />
  </a>
  <a href='https://breez.technology'>
    <img src='https://drive.google.com/uc?id=16gD7djk_o8YZnk8BMypVAR8HPdI4cRRd&export=download' height='400' alt='screenshot' />
  </a>
    <a href='https://breez.technology'>
    <img src='https://drive.google.com/uc?id=1Cf1-9hX5ri0gsgU4qhM3-Flt-J5RWuFK&export=download' height='400' alt='screenshot' />
  </a>
  <a href='https://breez.technology'>
    <img src='https://drive.google.com/uc?id=1hHzDMW4JlauGlgOncUpCyzjk8qmeD4QI&export=download' height='400' alt='screenshot' />
  </a>
</p>

Breez is a Lightning Network [mobile client](https://github.com/breez/breezmobile) and a [hub](https://github.com/breez/server). It provides a platform for simple, instantaneous bitcoin payments.

## Features

- [x] lnd on Android
- [x] Neutrino on Android
- [x] Seamless hub channel creation
- [x] Adding funds using on-chain tx
- [x] BTC, Bit & Satoshi units
- [x] Random avatars
- [x] Connect to Pay: simple interface to execute payments between users
- [x] POS interface
- [x] Pay someone nearby: pay to another Breez user using NFC
- [x] NFC card support: activate an NFC card to be used by POS
- [x] A full lncli interface to query and execute ln commands
- [x] Filter tx by type
- [x] Filter tx by date
- [ ] Pay invoice (link or QR) from other ln wallets
- [ ] Create invoice (link or QR) to be paid by other ln wallets
- [ ] SubmarineSwaps for adding on-chain funds
- [ ] Removing funds 
- [ ] Make Connect-to-Pay links work for users that didn't yet install Breez
- [ ] End-to-end encryption of Connect-to-Pay session
- [ ] Ability to Backup/Restore the ln node  
- [ ] Mainnet support
- [ ] Add mobile device security
- [ ] Use static card IDs
- [ ] NFC card deactivation
- [ ] Fiat units
- [ ] Watchtower
- [ ] Adding funds using fiat
- [ ] lnd on iOS

## Build & Run
1. Build `breez.aar` as decribed in https://github.com/breez/breez
2. Put `breez.aar` in `android/app/libs/` directory
3. Create `lnd.conf` in the `conf` directory with the following content:
```
[Application Options]
debuglevel=debug
noseedbackup=1
nolisten=1
rpcmemlisten=1
nobootstrap=1
maxbackoff=2s
[Bitcoin]
bitcoin.active=1
bitcoin.node=neutrino
bitcoin.defaultchanconfs=1
[Routing]
routing.assumechanvalid=1
[Neutrino]
neutrino.connect=<bitcoin node supporting bip157/bip158>
```
4. Create `breez.conf` in the `conf` directory with the following content:
```
[Application Options]
network=simnet #or testnet/mainnet
routingnodehost=<hubnode hostname:port>
routingnodepubkey=<hubnode pubkey>
breezserver=<host:port> #This is the server running https://github.com/breez/server
```
5. Assuming that you have already installed and configured flutter, you can use the following commands to run in a connected device the client app or the pos or to build the corresponding apks:
 - flutter run --flavor=client --target=lib/main.dart
 - flutter run --flavor=pos    --target=lib/main_pos.dart
 - flutter build apk --target-platform=android-arm64 --flavor=client --debug   --target=lib/main.dart
 - flutter build apk --target-platform=android-arm64 --flavor=pos    --debug   --target=lib/main_pos.dart

## Architecture 
<p align='center'>
  <a href='https://breez.technology'>
    <img src='https://drive.google.com/uc?id=1s695NXHHlhfvtW1zdlntUzRloxhnBeg0&export=download' height='450' alt='screenshot' />
  </a>
</p>
