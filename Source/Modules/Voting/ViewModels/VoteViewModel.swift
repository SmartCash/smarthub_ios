//
//  VoteViewModel.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 25/10/18.
//  Copyright © 2018 Erick Vavretchek. All rights reserved.
//

import Foundation

protocol VoteViewControllerProtocol: class {
  func populateData(proposal: Proposal)
  func displayError(message: String)
  func votedSuccessfully(message: String)
  func startLoading()
  func stopLoading()
}

class VoteViewModel {
  
  unowned let viewController: VoteViewControllerProtocol
  let smartCashApiStore: SmartcashAPIStore
  var proposal: Proposal
  
  init(viewController: VoteViewControllerProtocol,
       smartCashApiStore: SmartcashAPIStore = SmartcashAPIStore(),
       proposal: Proposal) {
    self.viewController = viewController
    self.smartCashApiStore = smartCashApiStore
    self.proposal = proposal
  }
  
  func viewDidLoad() {
    viewController.populateData(proposal: proposal)
  }
  
  func castVote(address: String, voteType: String, userKey: String) {
    viewController.startLoading()
    smartCashApiStore.castVote(proposalId: proposal.id, proposalUrl: proposal.url, from: address, voteType: voteType, userKey: userKey) { [weak self] result in
      self?.viewController.stopLoading()
      switch result {
      case .success(let value):
        print(value)
        self?.viewController.votedSuccessfully(message: "Your vote was successfully sent!")
      case .failure(let error):
        print(error.localizedDescription)
        self?.viewController.displayError(message: "Something went wrong. Check your password and try again.")
      }
    }
  }
}
