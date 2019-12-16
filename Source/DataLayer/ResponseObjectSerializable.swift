//
//  ResponseObjectSerializable.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 8/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ResponseObjectSerializable {
  init?(json: JSON)
}

protocol ResponseCollectionSerializable {
  static func collection(json: JSON) -> [Self]
}

extension ResponseCollectionSerializable where Self: ResponseObjectSerializable {
  static func collection(json: JSON) -> [Self] {
    return json.array?.flatMap { Self(json: $0) } ?? []
  }
}
