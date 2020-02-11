# Breez Mobile Client

<p align='center'>
  <a href='https://drive.google.com/open?id=1MHi-sdhoOXTxnlkwa2Eg0e6LThr0r_x-'>
    <img src='https://drive.google.com/uc?id=1MHi-sdhoOXTxnlkwa2Eg0e6LThr0r_x-&export=download' height='350' alt='screenshot' />
  </a>
  <a href='https://drive.google.com/open?id=16gD7djk_o8YZnk8BMypVAR8HPdI4cRRd'>
    <img src='https://drive.google.com/uc?id=16gD7djk_o8YZnk8BMypVAR8HPdI4cRRd&export=download' height='350' alt='screenshot' />
  </a>
  <a href='https://drive.google.com/open?id=1hHzDMW4JlauGlgOncUpCyzjk8qmeD4QI'>
    <img src='https://drive.google.com/uc?id=1hHzDMW4JlauGlgOncUpCyzjk8qmeD4QI&export=download' height='350' alt='screenshot' />
  </a>
    <a href='https://drive.google.com/open?id=1oOxChmEKd7c_AKZ_2ACgIBA56OFt6wGo'>
    <img src='https://drive.google.com/uc?id=1oOxChmEKd7c_AKZ_2ACgIBA56OFt6wGo&export=download' height='350' alt='screenshot' />
  </a>
  <a href='https://drive.google.com/open?id=1Cf1-9hX5ri0gsgU4qhM3-Flt-J5RWuFK'>
    <img src='https://drive.google.com/uc?id=1Cf1-9hX5ri0gsgU4qhM3-Flt-J5RWuFK&export=download' height='350' alt='screenshot' />
  </a>
</p>

[Breez](https://breez.technology) is a Lightning Network [mobile client](https://github.com/breez/breezmobile) and a [hub](https://github.com/breez/server). It provides a platform for simple, instantaneous bitcoin payments.

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
- [x] Pay invoice (link or QR) from other ln wallets
- [x] Create invoice (link or QR) to be paid by other ln wallets
- [x] Removing funds to an on-chain address
- [x] SubmarineSwaps for adding on-chain funds including refund functionality
- [x] End-to-end encryption of Connect-to-Pay session
- [x] Make Connect-to-Pay links work for users that didn't yet install Breez
- [x] Ability to Backup/Restore the ln node  
- [x] Mainnet support
- [x] Support zero-sat invoices
- [x] Startup optimizations
- [x] Background sync via FCM
- [x] Marketplace w/ Bitrefill
- [x] Adding funds via vouchers
- [x] Backup improvements
- [x] Add background ChannelsWatcher job
- [x] Expose Bitcoin Node (BIP157) configuration
- [x] iOS support
- [x] Add webLN support
- [x] Fiat units
- [ ] iCloud backup option
- [ ] Add encryption to cloud backup
- [ ] Use static card IDs
- [ ] NFC card deactivation
- [ ] Adding funds via credit card
- [ ] Simplify P2P payments
- [ ] Support zero-conf 

## System Requirements
* Android 7+ 64bit

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
