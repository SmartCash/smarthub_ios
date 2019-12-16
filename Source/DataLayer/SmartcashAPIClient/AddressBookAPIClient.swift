//
//  AddressBookAPIClient.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 8/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import Alamofire

class AddressBookAPIClient {
  
  func getContacts(accessToken: AccessToken, completionHandler: @escaping (DataResponse<AddressBookAPI>) -> Void) {
    Alamofire.request(AddressBookRouter.get(accessToken: accessToken))
      .validate()
      .responseObject(completionHandler: completionHandler)
  }
  
  func createContact(accessToken: AccessToken, name: String, address: String, completionHandler: @escaping (DataResponse<Any>) -> Void) {
    Alamofire.request(AddressBookRouter.create(accessToken: accessToken, name: name, address: address))
      .validate()
      .responseJSON(completionHandler: completionHandler)
  }
  
  func deleteContact(accessToken: AccessToken, id: Int, completionHandler: @escaping (DataResponse<Any>) -> Void) {
    Alamofire.request(AddressBookRouter.delete(accessToken: accessToken, id: id))
      .validate()
      .responseJSON(completionHandler: completionHandler)
  }
}

enum AddressBookRouter: SmartcashWalletAPIRouter {
  
  case get(accessToken: AccessToken)
  case create(accessToken: AccessToken, name: String, address: String)
  case delete(accessToken: AccessToken, id: Int)
  
  var method: HTTPMethod {
    switch self {
    case .get:
      return .get
    case .create:
      return .post
    case .delete:
      return .delete
    }
  }
  
  var queryString: String? {
    switch self {
    case let .delete(_, id):
      return "contactId=\(id)"
    default: return nil
    }
  }
  
  var path: String {
    switch self {
    case .get:
      return "api/contact/my"
    case .create:
      return "api/contact"
    case .delete:
      return "api/contact"
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .get(let accessToken):
      return ["Authorization": "Bearer \(accessToken)"]
    case .create(let accessToken, _, _):
      return ["Authorization": "Bearer \(accessToken)"]
    case .delete(let accessToken, _):
      return ["Authorization": "Bearer \(accessToken)"]
    }
  }
  
  var parameters: Parameters? {
    switch self {
    case let .create(_, name, address):
      return [
        "Name": name,
        "Address": address
      ]
    case .get:
      return nil
    case .delete:
      return nil
    }
  }
}
