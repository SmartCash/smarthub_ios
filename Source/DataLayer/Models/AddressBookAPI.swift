//
//  AddressBookAPI.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 8/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AddressBookAPI {
  let addresses: [Address]
  let status: String
  let isValid: Bool
}

extension AddressBookAPI: ResponseObjectSerializable, ResponseCollectionSerializable {
  init?(json: JSON) {
    guard
      let _ = json["data"].array,
      let status = json["status"].string,
      let isValid = json["isValid"].bool
      else { return nil }
    
    let addresses = Address.collection(json: json["data"])
    
    self.status = status
    self.isValid = isValid
    self.addresses = addresses
  }
}

struct Address: Equatable {
  let id: Int
  let name: String
  let address: String
  
  static func == (lhs: Address, rhs: Address) -> Bool {
    return lhs.id == rhs.id
  }
}

extension Address: ResponseObjectSerializable, ResponseCollectionSerializable {
  init?(json: JSON) {
    guard
      let id = json["contactId"].int,
      let name = json["name"].string,
      let address = json["address"].string
      else { return nil }
    
    self.id = id
    self.name = name
    self.address = address
  }
}


