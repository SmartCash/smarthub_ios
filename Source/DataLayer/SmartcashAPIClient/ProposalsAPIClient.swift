//
//  VotingAPIClient.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 17/10/18.
//  Copyright © 2018 Erick Vavretchek. All rights reserved.
//

import Foundation
import Alamofire

class ProposalsAPIClient {
  
  func getProposals(completionHandler: @escaping (DataResponse<Data>) -> Void) {
    Alamofire.request(ProposalsRouter.getProposals)
      .validate()
      .responseData(completionHandler: completionHandler)
    
    
    
    
    //        switch response.result {
    //        case .success:
    //          if((response.result) != nil) {
    //            let jsonData = response.data
    //
    
    //            do {
    //            let get = try JSONDecoder().decode(ProposalGetAPI.self, from: jsonData!)
    //              print(get)
    //            } catch  {
    //              print(error)
    //            }
    //          }
    //        case .failure(let error):
    //          print(error.localizedDescription)
    //        }
  }
  
  func getProposalDetails(id: String, completionHandler: @escaping (DataResponse<Data>) -> Void) {
    Alamofire.request(ProposalsRouter.getDetails(id: id))
      .validate()
      .responseData(completionHandler: completionHandler)
  }
}

enum ProposalsRouter: ProposalsAPIRouter {
  
  case getProposals
  case getDetails(id: String)
  //  case create(accessToken: AccessToken, name: String, address: String)
  //  case delete(accessToken: AccessToken, id: Int)
  
  var method: HTTPMethod {
    switch self {
    case .getProposals:
      return .get
    case .getDetails:
      return .get
    }
  }
  
//    var queryString: String? {
//      switch self {
//      case let .getDetails(id):
//        return "contactId=\(id)"
//      default: return nil
//      }
//    }
  
  var path: String {
    switch self {
    case .getProposals:
      return "api/v1/proposals"
    case let .getDetails(id):
      return "api/v1/proposals/simplifieddetails/\(id)"
    }
  }
  
  //  var headers: [String : String]? {
  //    switch self {
  //    case .get(let accessToken):
  //      return ["Authorization": "Bearer \(accessToken)"]
  //    case .create(let accessToken, _, _):
  //      return ["Authorization": "Bearer \(accessToken)"]
  //    case .delete(let accessToken, _):
  //      return ["Authorization": "Bearer \(accessToken)"]
  //    }
  //  }
  
  //  var parameters: Parameters? {
  //    switch self {
  //    case let .create(_, name, address):
  //      return [
  //        "Name": name,
  //        "Address": address
  //      ]
  //    case .get:
  //      return nil
  //    case .delete:
  //      return nil
  //    }
  //  }
}
