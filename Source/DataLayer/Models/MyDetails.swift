//
//  MyDetails.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 15/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import SwiftyJSON

class MyDetails {
  static let shared = MyDetails()
  //  var myWallets: MyWalletsAPI?
  var allWallets: [Wallet]?
  var addressBook: [Address]?
}

struct MyDetailsAPI {

  let wallets: [Wallet]
  let is2FAEnabled: Bool
  let status: String
  let isValid: Bool
}

struct Wallet: Equatable {
  let displayName: String
  let address: String
  let qrCode: URL
  let balance: Double
  let totalSent: Double
  let totalReceived: Double
  let transactions: [Transaction]
  
  public static func ==(lhs: Wallet, rhs: Wallet) -> Bool {
    return lhs.address == rhs.address
  }
}

extension Wallet {
  @objc(_TtCV15SmartcashWallet6Wallet11WalletClass)class WalletClass: NSObject, NSCoding {
    var wallet: Wallet
    init(wallet: Wallet) {
      self.wallet = wallet
      //      self.wallet.transactions = wallet.transactions.map{ Transaction.TransactionClass(transaction: $0)}
      super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
      guard let displayName = aDecoder.decodeObject(forKey: "displayName") as? String else { return nil }
      guard let address = aDecoder.decodeObject(forKey: "address") as? String else { return nil }
      guard let balance = aDecoder.decodeDouble(forKey: "balance") as? Double else { return nil }
      guard let qrCode = aDecoder.decodeObject(forKey: "qrCode") as? URL else { return nil }
      guard let totalSent = aDecoder.decodeDouble(forKey: "totalSent") as? Double else { return nil }
      guard let totalReceived = aDecoder.decodeDouble(forKey: "totalReceived") as? Double else { return nil }
      guard let transactionsClass = aDecoder.decodeObject(forKey: "transactions") as? [Transaction.TransactionClass] else { return nil }
      let transactions = transactionsClass.map{ Transaction(hash: $0.transaction.hash, timestamp: $0.transaction.timestamp, amount: $0.transaction.amount, direction: $0.transaction.direction, toAddress: $0.transaction.toAddress, isPending: $0.transaction.isPending, blockindex: $0.transaction.blockindex) }
      
      wallet = Wallet(displayName: displayName, address: address, qrCode: qrCode, balance: balance, totalSent: totalSent, totalReceived: totalReceived, transactions: transactions)
      super.init()
    }
    
    func encode(with aCoder: NSCoder) {
      aCoder.encode(wallet.displayName, forKey: "displayName")
      aCoder.encode(wallet.address, forKey: "address")
      aCoder.encode(wallet.qrCode, forKey: "qrCode")
      aCoder.encode(wallet.balance, forKey: "balance")
      aCoder.encode(wallet.totalSent, forKey: "totalSent")
      aCoder.encode(wallet.totalReceived, forKey: "totalReceived")
      aCoder.encode(wallet.transactions.map{ Transaction.TransactionClass(transaction: $0)}, forKey: "transactions")
    }
  }
}

struct Transaction {
  
  //  enum Direction {
  //    case send
  //    case receive
  //  }
  
  let hash: String
  let timestamp: String
  let amount: Double
  let direction: String
  let toAddress: String
  let isPending: Bool
  let blockindex: Int
}

extension Transaction {
  @objc(_TtCV15SmartcashWallet11Transaction16TransactionClass)class TransactionClass: NSObject, NSCoding {
    var transaction: Transaction
    init(transaction: Transaction) {
      self.transaction = transaction
      super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
      guard let hash = aDecoder.decodeObject(forKey: "hash") as? String else { return nil }
      guard let timestamp = aDecoder.decodeObject(forKey: "timestamp") as? String else { return nil }
      guard let amount = aDecoder.decodeDouble(forKey: "amount") as? Double else { return nil }
      guard let direction = aDecoder.decodeObject(forKey: "direction") as? String else { return nil }
      guard let toAddress = aDecoder.decodeObject(forKey: "toAddress") as? String else { return nil }
      guard let blockindex = aDecoder.decodeInteger(forKey: "blockindex") as? Int else { return nil }
      
      let isPending = aDecoder.decodeBool(forKey: "isPending")
      
      transaction = Transaction(hash: hash, timestamp: timestamp, amount: amount, direction: direction, toAddress: toAddress, isPending: isPending, blockindex: blockindex)
      super.init()
    }
    
    func encode(with aCoder: NSCoder) {
      aCoder.encode(transaction.hash, forKey: "hash")
      aCoder.encode(transaction.timestamp, forKey: "timestamp")
      aCoder.encode(transaction.amount, forKey: "amount")
      aCoder.encode(transaction.direction, forKey: "direction")
      aCoder.encode(transaction.toAddress, forKey: "toAddress")
      aCoder.encode(transaction.blockindex, forKey: "blockindex")
      aCoder.encode(transaction.isPending, forKey: "isPending")
    }
  }
}

extension MyDetailsAPI: ResponseObjectSerializable, ResponseCollectionSerializable {
  init?(json: JSON) {
    guard
      let _ = json["data"]["wallet"].array,
      let status = json["status"].string,
      let isValid = json["isValid"].bool,
      let is2FAEnabled = json["data"]["is2FAEnabled"].bool
      else { return nil }
    
    let wallets = Wallet.collection(json: json["data"]["wallet"])
    
    self.status = status
    self.isValid = isValid
    self.wallets = wallets
    self.is2FAEnabled = is2FAEnabled
    
    MyDetails.shared.allWallets = wallets
    let authStore = AuthStore()
    authStore.keychainClient.wallets = wallets
    authStore.save2FAStatus(enabled: is2FAEnabled)
  }
}

extension Wallet: ResponseObjectSerializable, ResponseCollectionSerializable {
  init?(json: JSON) {
    guard
      let displayName = json["displayName"].string,
      let address = json["address"].string,
      let qrCode = json["qrCode"].url,
      let balance = json["balance"].double,
      let totalSent = json["totalSent"].double,
      let totalReceived = json["totalReceived"].double,
      let _ = json["transactions"].array
      else { return nil }
    
    self.displayName = displayName
    self.address = address
    self.qrCode = qrCode
    self.balance = balance
    self.totalSent = totalSent
    self.totalReceived = totalReceived
    self.transactions = Transaction.collection(json: json["transactions"])
  }
}

extension Transaction: ResponseObjectSerializable, ResponseCollectionSerializable {
  init?(json: JSON) {
    guard
      let hash = json["hash"].string,
      let timestamp = json["timestamp"].string,
      let amount = json["amount"].double,
      let direction = json["direction"].string,
      let toAddress = json["toAddress"].string,
      let isPending = json["isPending"].bool,
      let blockindex = json["blockindex"].int
      else { return nil }
    self.hash = hash
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let date = dateFormatter.date(from: timestamp)
    let dateFormatter2 = DateFormatter()
    dateFormatter2.dateFormat = "HH:mm a - MMM d, yyyy"
    dateFormatter2.amSymbol = "AM"
    dateFormatter2.pmSymbol = "PM"
    if let date = date {
      self.timestamp = dateFormatter2.string(from: date)
    } else {
      self.timestamp = timestamp
    }
    
    self.amount = amount
    self.direction = direction
    self.toAddress = toAddress
    self.isPending = isPending
    self.blockindex = blockindex
  }
}

