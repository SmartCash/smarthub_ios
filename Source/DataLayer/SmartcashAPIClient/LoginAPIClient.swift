//
//  LoginAPIClient .swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 10/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import Alamofire

class LoginAPIClient {
  
  func login(username: String, password: String, twoFACode: String, completionHandler: @escaping (DataResponse<LoginAPI>) -> Void) {
    Alamofire.request(LoginRouter.login(username: username, password: password, twoFACode: twoFACode))
      .validate()
      .responseObject(completionHandler: completionHandler)
  }
}

enum LoginRouter: SmartcashWalletAPIRouter {
  
  case login(username: String, password: String, twoFACode: String)
  
  var method: HTTPMethod {
    return .post
  }
  
  var path: String {
    return "api/user/authenticate"
  }
  
  
  func asURLRequest() throws -> URLRequest {
    var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    

    
    var parameters: Parameters {
      switch self {
      case let .login(username, password, twoFACode):
        return [
          "username": username,
          "password": password,
          "grant_type" : AppConfigStore.shared.smartcashLoginGrantType,
          "client_id": AppConfigStore.shared.smartcashAPIClientId,
          "client_secret": AppConfigStore.shared.smartcashAPIClientSecret,
          "TwoFactorAuthentication": twoFACode,
          "Client_IP": "10.0.0.1",
          "client_type": "mobile"
        ]
      }
    }
    return try URLEncoding.methodDependent.encode(urlRequest, with: parameters)
  }
}
