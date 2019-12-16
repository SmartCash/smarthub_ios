//
//  KeychainClient .swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 10/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import KeychainAccess

class KeychainClient {
  
  private let keychain: Keychain
  
  
  
  
//  init(keychain: Keychain = Keychain(service: "cc.smartcash.wallet")
  init(keychain: Keychain = Keychain(server: "https://wallet.smartcash.cc", protocolType: .https)
    .label("SmartCash Wallet")
    .synchronizable(true)
    .accessibility(.afterFirstUnlock)) {
    self.keychain = keychain
  }
  
  var userId: UserId? {
    get {
      if let userId = try? keychain.get("userId") {
        return userId
      }
      return nil
    }
    set {
      keychain["userId"] = newValue
    }
  }
  
  var username: Username? {
    get {
      if let username = try? keychain.get("username") {
        return username
      }
      return nil
    }
    set {
      keychain["username"] = newValue
    }
  }
  
  var userPassword: UserPassword? {
    get {
      if let userPassword = try? keychain.get("userPassword") {
        return userPassword
      }
      return nil
    }
    set {
      keychain["userPassword"] = newValue
    }
  }
  
  var accessTokenExpiration: String? {
    get {
      if let accessTokenExpiration = try? keychain.get("accessTokenExpiration") {
        return accessTokenExpiration
      }
      return nil
    }
    set {
      keychain["accessTokenExpiration"] = newValue
    }
  }
  
  var recoveryKey: RecoveryKey? {
    get {
      if let recoveryKey = try? keychain.get("recoveryKey") {
        return recoveryKey
      }
      return nil
    }
    set {
      keychain["recoveryKey"] = newValue
    }
  }
  
  var deviceId: DeviceId? {
    get {
      if let deviceId = try? keychain.get("deviceId") {
        return deviceId
      }
      return nil
    }
    set {
      keychain["deviceId"] = newValue
    }
  }
  
  var accessToken: AccessToken? {
    get {
      if let accessToken = try? keychain.get("accessToken") {
        return accessToken
      }
      return nil
    }
    set {
      keychain["accessToken"] = newValue
    }
  }
  
  var refreshToken: RefreshToken? {
    get {
      if let refreshToken = try? keychain.get("refreshToken") {
        return refreshToken
      }
      return nil
    }
    set {
      keychain["refreshToken"] = newValue
    }
  }
  
  var wallets: [Wallet]? {
    get {
      if let wallets = try? keychain.getData("wallets") {
        guard wallets != nil  else { return nil }
        if let walletsArray = NSKeyedUnarchiver.unarchiveObject(with: wallets!) as? [Wallet.WalletClass] {
          return walletsArray.map{ Wallet(displayName: $0.wallet.displayName, address: $0.wallet.address, qrCode: $0.wallet.qrCode, balance: $0.wallet.balance, totalSent: $0.wallet.totalSent, totalReceived: $0.wallet.totalReceived, transactions: $0.wallet.transactions) }
        }
      }
      return nil
    }
    set {
      guard newValue != nil else {
        keychain[data: "wallets"] = nil
        return
      }
      let walletsObj = newValue!.map{Wallet.WalletClass(wallet: $0)}
      let walletsData = NSKeyedArchiver.archivedData(withRootObject: walletsObj)
      keychain[data: "wallets"] = walletsData
    }
  }
  
  struct Person: Codable {
    let name: String
    let age: Int
  }
}
