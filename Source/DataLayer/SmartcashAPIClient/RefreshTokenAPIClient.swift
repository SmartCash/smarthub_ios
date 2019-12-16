//
//  RefreshTokenAPIClient .swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 10/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import Alamofire

class RefreshTokenAPIClient {
  
  func refresh(refreshToken: String, completionHandler: @escaping (DataResponse<LoginAPI>) -> Void) {
    Alamofire.request(RefreshTokenRouter.refresh(refreshToken: refreshToken))
      .validate()
      .responseObject(completionHandler: completionHandler)
  }
}

enum RefreshTokenRouter: SmartcashWalletAPIRouter {
  
  case refresh(refreshToken: String)
  
  var method: HTTPMethod {
    return .post
  }
  
  var path: String {
    return "api/user/authenticate"
  }
  
  var parameters: Parameters? {
    switch self {
    case let .refresh(refreshToken):
      return [
        "refresh_tokem": refreshToken,
        "grant_type" : AppConfigStore.shared.smartcashLoginGrantType,
        "client_id": AppConfigStore.shared.smartcashAPIClientId,
        "client_secret": AppConfigStore.shared.smartcashAPIClientSecret
      ]
    }
  }
}
