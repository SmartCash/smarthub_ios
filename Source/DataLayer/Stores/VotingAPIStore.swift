//
//  VotingAPIStore.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 17/10/18.
//  Copyright © 2018 Erick Vavretchek. All rights reserved.
//

import Foundation
import Alamofire

class VotingAPIStore {
  
  let proposalsAPIClient: ProposalsAPIClient
  
  init(proposalsAPIClient: ProposalsAPIClient = ProposalsAPIClient()) {
    self.proposalsAPIClient = proposalsAPIClient
  }
  
  func getProposals(completionHandler: @escaping (Result<ProposalGetAPI>) -> Void) {
    proposalsAPIClient.getProposals { (response) in
      completionHandler(JSONDecoder().decodeResponse(ProposalGetAPI.self, from: response))
    }
  }
  
  func getProposalDetails(id: String, completionHandler: @escaping (Result<ProposalDetailsGetAPI>) -> Void) {
    proposalsAPIClient.getProposalDetails(id: id) { (response) in
      completionHandler(JSONDecoder().decodeResponse(ProposalDetailsGetAPI.self, from: response))
    }
  }
}
