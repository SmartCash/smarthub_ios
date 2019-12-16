//
//  Url.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 26/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation

extension URL {
  var params: [String: String]? {
    if let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) {
      if let queryItems = urlComponents.queryItems {
        var params = [String: String]()
        queryItems.forEach{
          params[$0.name] = $0.value
        }
        return params
      }
    }
    return nil
  }
}
