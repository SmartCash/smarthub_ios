//
//  SendAPIClient.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 26/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import Alamofire


class SendPaymentAPIClient {
  
  func pay(accessToken: AccessToken, from: String, to: String, amount: Decimal, userKey: String, completionHandler: @escaping (DataResponse<Any>) -> Void) {
    Alamofire.request(SendPaymentRouter.pay(accessToken: accessToken, from: from, to: to, amount: amount, userKey: userKey))
      .validate()
      .responseJSON(completionHandler: completionHandler)
  }
}

enum SendPaymentRouter: SmartcashWalletAPIRouter {
  
  case pay(accessToken: AccessToken,from: String, to: String, amount: Decimal, userKey: String)
  
  var method: HTTPMethod {
    return .post
  }
  
  var path: String {
    return "api/wallet/sendpayment"
  }
  
  var headers: [String : String]? {
    switch self {
    case .pay(let accessToken, _, _, _, _):
      return ["Authorization": "Bearer \(accessToken)"]
    }
  }
  
  var parameters: Parameters? {
    switch self {
    case let .pay(_, from, to, amount, userKey):
      return [
        "FromAddress": from,
        "ToAddress": to,
        "Amount": amount,
        "UserKey": userKey
      ]
    }
  }
}
