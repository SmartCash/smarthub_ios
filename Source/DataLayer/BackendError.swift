//
//  BackendError.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 8/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation

enum BackendError: Error {
  case noNetworkConnection
  case networkTimeout
  case network(error: Error)
  case jsonSerialization(error: Error)
  case objectSerialization(reason: String)
  case codableData(reson: String)
  
  init(error: Error) {
    let error = error as NSError
    
    switch error.code {
    case NSURLErrorTimedOut where error.domain == NSURLErrorDomain:
      self = .networkTimeout
    case NSURLErrorNotConnectedToInternet where error.domain == NSURLErrorDomain:
      self = .noNetworkConnection
    default:
      self = .network(error: error)
    }
  }
}
