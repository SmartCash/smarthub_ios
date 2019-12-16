//
//  LogOffAPIClient.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 26/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import Alamofire

class LogOffAPIClient {
  
  func logOff(accessToken: String, completionHandler: @escaping (DataResponse<Any>) -> Void) {
    Alamofire.request(LogOffRouter.logOff(accessToken: accessToken))
      .validate()
      .responseJSON(completionHandler: completionHandler)
  }
}

enum LogOffRouter: SmartcashWalletAPIRouter {
  
  case logOff(accessToken: AccessToken)
  
  var method: HTTPMethod {
    return .get
  }
  
  var path: String {
    return "api/user/logout"
  }
  
  var headers: [String : String]? {
    switch self {
    case .logOff(let accessToken):
      return ["Authorization": "Bearer \(accessToken)"]
    }
  }
}

