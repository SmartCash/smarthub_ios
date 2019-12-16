//
//  PrivateKeyAPIClient.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 16/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import Alamofire

class PrivateKeyAPIClient {
  
  func importPrivateKey(accessToken: AccessToken, privateKey: String, recoveryKey: RecoveryKey, password: String, label: String, completionHandler: @escaping (DataResponse<Any>) -> Void) {
    Alamofire.request(PrivateKeyRouter.importPK(accessToken: accessToken, privateKey: privateKey, recoveryKey: recoveryKey, password: password, label: label))
      .validate()
      .responseJSON(completionHandler: completionHandler)
  }
  
  func exportPrivateKey(accessToken: AccessToken, recoveryKey: RecoveryKey, completionHandler: @escaping (DataResponse<ExportPrivateKeyAPI>) -> Void) {
    Alamofire.request(PrivateKeyRouter.exportPK(accessToken: accessToken, recoveryKey: recoveryKey))
      .validate()
      .responseObject(completionHandler: completionHandler)
  }
}

enum PrivateKeyRouter: SmartcashWalletAPIRouter {
  
  case importPK(accessToken: AccessToken, privateKey: String, recoveryKey: RecoveryKey, password: String, label: String)
  case exportPK(accessToken: AccessToken, recoveryKey: RecoveryKey)

  var method: HTTPMethod {
    switch self {
    case .importPK:
      return .post
    case .exportPK:
      return .post
    }
  }
  
  var path: String {
    switch self {
    case .importPK:
      return "api/wallet/importprivatekeys"
    case .exportPK:
      return "api/wallet/exportprivatekeys"
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .importPK(let accessToken, _, _, _, _):
      return ["Authorization": "Bearer \(accessToken)"]
    case .exportPK(let accessToken, _):
      return ["Authorization": "Bearer \(accessToken)"]
    }
  }
  
  var parameters: Parameters? {
    switch self {
    case let .importPK(_, privateKey, recoveryKey, password, label):
      return [
        "privateKey": privateKey,
        "RecoveryKey": recoveryKey,
        "UserKey": password,
        "Label": label,
        "IsRewards": true
        ]
    case let .exportPK(_, recoveryKey):
      return ["data": recoveryKey]
    }
  }
}


