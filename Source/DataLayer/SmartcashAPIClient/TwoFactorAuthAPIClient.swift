//
//  TwoFactorAuthAPIClient.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 12/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import Alamofire

class TwoFactorAuthAPIClient {
  
  func get2FA(accessToken: AccessToken, completionHandler: @escaping (DataResponse<TwoFactorAuthAPI>) -> Void) {
    Alamofire.request(TwoFactorAuthRouter.get(accessToken: accessToken))
      .validate()
      .responseObject(completionHandler: completionHandler)
  }
  
  func enable(gaCode: String, accessToken: AccessToken, completionHandler: @escaping (DataResponse<Any>) -> Void) {
    Alamofire.request(TwoFactorAuthRouter.enable(gaCode: gaCode, accessToken: accessToken))
      .validate()
      .responseJSON(completionHandler: completionHandler)
  }
  
  func disable(recoveryKey: RecoveryKey, accessToken: AccessToken, completionHandler: @escaping (DataResponse<Any>) -> Void) {
    Alamofire.request(TwoFactorAuthRouter.disable(recoveryKey: recoveryKey, accessToken: accessToken))
      .validate()
      .responseJSON(completionHandler: completionHandler)
  }
}

enum TwoFactorAuthRouter: SmartcashWalletAPIRouter {
  
  case get(accessToken: AccessToken)
  case enable(gaCode: String, accessToken: AccessToken)
  case disable(recoveryKey: RecoveryKey, accessToken: AccessToken)

  var method: HTTPMethod {
    switch self {
    case .get:
      return .get
    case .enable:
      return .post
    case .disable:
      return .post
    }
  }
  
  var path: String {
    switch self {
    case .get:
      return "api/user/2FA/new"
    case .enable:
      return "api/user/2fa/enable"
    case .disable:
      return "api/user/2fa/disable"
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .get(let accessToken):
      return ["Authorization": "Bearer \(accessToken)"]
    case .enable(_, let accessToken):
      return ["Authorization": "Bearer \(accessToken)"]
    case .disable(_, let accessToken):
      return ["Authorization": "Bearer \(accessToken)"]
    }
  }
  
  var parameters: Parameters? {
    switch self {
    case .get:
      return nil
    case .enable(let gaCode, _):
      return ["data": gaCode]
    case .disable(let recoveryKey, _):
      return ["data": recoveryKey]
    }
  }
}

