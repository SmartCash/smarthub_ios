//
//  Environment.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 8/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation

enum Environment: String {
  case prod, dev
  
  var smartcashBaseURL: URL {
    switch self {
    case .prod:
      return URL(string: "https://smartcashapiprod.azurewebsites.net/")!
    case .dev:
      return URL(string: "https://smartcashapi.azurewebsites.net/")!
    }
  }
  
  var votingBaseURL: URL {
    return URL(string: "https://vote.smartcash.cc/")!
  }
  
  var smartcashAPIClientId: String {
    switch self {
    case .prod:
      return "81d46070-686b-4975-9c29-9ebc867a3c4e"
    case .dev:
      return "81d46070-686b-4975-9c29-9ebc867a3c4e"
    }
  }
  
  var smartcashAPIClientSecret: String {
    switch self {
    case .prod:
      return "B3EIldyQp5Hl2CXZdP8MeYmDl3gXb3tan4XCNg0ZK0"
    case .dev:
      return "B3EIldyQp5Hl2CXZdP8MeYmDl3gXb3tan4XCNg0ZK0"
    }
  }
  
  var smartcashLoginGrantType: String {
    switch self {
    case .prod:
      return "password"
    case .dev:
      return "password"
    }
  }
}
