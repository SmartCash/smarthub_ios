//
//  CastVoteAPIClient.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 25/10/18.
//  Copyright © 2018 Erick Vavretchek. All rights reserved.
//

import Foundation
import Alamofire


class CastVoteAPIClient {
  
  func vote(accessToken: AccessToken, proposalId: Int, proposalUrl: String, from: String, voteType: String, userKey: String, completionHandler: @escaping (DataResponse<Any>) -> Void) {
    Alamofire.request(CastVoteRouter.vote(accessToken: accessToken, proposalId: proposalId, proposalUrl: proposalUrl, from: from, voteType: voteType, userKey: userKey))
      .validate()
      .responseJSON(completionHandler: completionHandler)
  }
}

enum CastVoteRouter: SmartcashWalletAPIRouter {
  
  case vote(accessToken: AccessToken, proposalId: Int, proposalUrl: String, from: String, voteType: String, userKey: String)
  
  var method: HTTPMethod {
    return .post
  }
  
  var path: String {
    return "api/vote/sendvote"
  }
  
  var headers: [String : String]? {
    switch self {
    case .vote(let accessToken, _, _, _, _, _):
      return ["Authorization": "Bearer \(accessToken)"]
    }
  }
  
  var parameters: Parameters? {
    switch self {
    case let .vote(_, proposalId, proposalUrl, from, voteType, userKey):
      return [
        "proposalId": proposalId,
        "fromAddress": from,
        "voteType": voteType,
        "userKey": userKey,
        "message": proposalUrl,
        "voteIP": ""
      ]
    }
  }
}
