//
//  MyDetailsAPIClient.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 15/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import Alamofire

class MyDetailsAPIClient {
  
  func get(accessToken: AccessToken, completionHandler: @escaping (DataResponse<MyDetailsAPI>) -> Void) {
    Alamofire.request(MyDetailsRouter.get(accessToken: accessToken))
      .validate()
      .responseObject(completionHandler: completionHandler)
  }
}

enum MyDetailsRouter: SmartcashWalletAPIRouter {
  
  case get(accessToken: AccessToken)
  
  var method: HTTPMethod {
    return .get
  }
  
  var path: String {
    return "api/user/my"
  }
  
  var headers: [String : String]? {
    switch self {
    case .get(let accessToken):
      return ["Authorization": "Bearer \(accessToken)"]
    }
  }
}

