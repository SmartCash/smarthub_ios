//
//  MyWallet .swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 11/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import Alamofire

//class MyWalletAPIClient {
//  
//  func get(accessToken: AccessToken, completionHandler: @escaping (DataResponse<MyDetailsAPI>) -> Void) {
//    Alamofire.request(MyWalletRouter.get(accessToken: accessToken))
//      .validate()
//      .responseObject(completionHandler: completionHandler)
//  }
//}
//
//enum MyWalletRouter: SmartcashWalletAPIRouter {
//  
//  case get(accessToken: AccessToken)
//  
//  var method: HTTPMethod {
//    return .get
//  }
//  
//  var path: String {
//    return "api/wallet/my"
//  }
//  
//  var headers: [String : String]? {
//    switch self {
//    case .get(let accessToken):
//      return ["Authorization": "Bearer \(accessToken)"]
//    }
//  }
//}

