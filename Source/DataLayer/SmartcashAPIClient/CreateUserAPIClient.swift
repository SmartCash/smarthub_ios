//
//  CreateUserAPIClient.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 8/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import Alamofire

typealias RecoveryKey = String

class CreateUserAPIClient {
  
  func createUser(username: String, password: String, recoveryKey: RecoveryKey, firstName: String, lastName: String, completionHandler: @escaping (DataResponse<CreateUserAPI>) -> Void) {
    Alamofire.request(CreateUserRouter.create(username: username, password: password, recoveryKey: recoveryKey, firstName: firstName, lastName: lastName))
      .validate()
      .responseObject(completionHandler: completionHandler)
  }
  
  func getRecoveryKey(completionHandler: @escaping (DataResponse<RecoveryKey>) -> Void) {
    Alamofire.request(CreateUserRouter.getRecoveryKey)
      .validate()
      .responseSwiftyJson { response in
        let recoveryKeyResponse = response.flatMap { json -> RecoveryKey in
          
          guard let recoveryKey = json["data"]["recoveryKey"].string else {
            let reason = "'recoveryKey' key not found"
            throw BackendError.objectSerialization(reason: reason)
          }
          return recoveryKey
        }
        
        completionHandler(recoveryKeyResponse)
    }
  }
}

enum CreateUserRouter: SmartcashWalletAPIRouter {
  
  case create(username: String, password: String, recoveryKey: RecoveryKey, firstName: String, lastName: String)
  case getRecoveryKey
  
  var method: HTTPMethod {
    switch self {
    case .create:
      return .post
    case .getRecoveryKey:
      return .get
    }
  }
  
  var path: String {
    switch self {
    case .create:
      return "api/user"
    case .getRecoveryKey:
      return "api/user/newkey"
    }
    
  }
  
  var parameters: Parameters? {
    switch self {
    case let .create(username, password, recoveryKey, firstName, lastName):
      return [
        "Username": username,
        "Password": password,
        "RecoveryKey": recoveryKey,
        "FirstName": firstName,
        "LastName": lastName
      ]
    default:
      return nil
    }
  }
}
