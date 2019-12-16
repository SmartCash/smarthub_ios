//
//  ExportPrivateKeyAPI.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 16/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ExportPrivateKeyAPI {
  let accounts: [PrivateKey]
}

extension ExportPrivateKeyAPI: ResponseObjectSerializable {
  init?(json: JSON) {
    guard let _ = json["data"].array else { return nil }
    self.accounts = PrivateKey.collection(json: json["data"])
  }
}

struct PrivateKey {
  let index: Int
  let address: String
  let privateKey: String
}

extension PrivateKey: ResponseObjectSerializable, ResponseCollectionSerializable {
  init?(json: JSON) {
    guard
      let index = json["index"].int,
      let address = json["address"].string,
      let privateKey = json["privateKey"].string
      else { return nil }
    self.index = index
    self.address = address
    self.privateKey = privateKey
  }
}
