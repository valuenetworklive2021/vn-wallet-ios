### Getting Started

1. [Download  Xcode 13](https://developer.apple.com/download/more/)
2. Clone this repository
3. Run `make bootstrap` to install tools and dependencies.

### Add your token to VN Wallet

If you’d like to include TokenScript and extend your token functionalities, please refer to [TokenScript](https://github.com/AlphaWallet/TokenScript).

### Add dApp to the “Discover dApps” section in the browser

Submit a PR to the following file:
https://github.com/valuenetworklive2021/vn-wallet-ios/blob/master/AlphaWallet/Browser/ViewModel/Dapps.swift


### Replace API Keys

API keys are stored in the file `AlphaWallet/Settings/Types/Constants+Credentials.swift`. You can replace the keys for your own build. Tell git to ignore changes to that file by running:

```
git update-index --assume-unchanged AlphaWallet/Settings/Types/Constants+Credentials.swift
```

Undo this with:

```
git update-index --no-assume-unchanged AlphaWallet/Settings/Types/Constants+Credentials.swift
```

### Localization

Format for localization keys:
`feature.section.element.type`, or could be simply as `feature.section.type`

Examples:
```
key: transactions.myAddress.button.title, 
value: My Address
comment: The title of the my address button on the transactions page

key: deposit.buy.button.coinbase.title, 
value: via Coinbase
comment: The title of the deposit button in the alert sheet

key: exchange.error.failedToGetRates
value: Failed to get rates
comment: Error messesage when failed to update rates on pairs of tokens



key: welcome.privateAndSecure.label.title
value: Private & Secure
comment: 

key: welcome.privateAndSecure.label.description
value: Private keys never leave your device.
comment:

```

Generic keys and values:
```
Ok - Ok
Cancel - Cancel
Done - Done
Send - Send
Refresh - Refresh
```
