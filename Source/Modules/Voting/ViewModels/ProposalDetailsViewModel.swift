//
//  ProposalDetailsViewModel.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 24/10/18.
//  Copyright © 2018 Erick Vavretchek. All rights reserved.
//

import Foundation

protocol ProposalDetailsViewControllerProtocol: class {
  func isLoadingData()
  func finishedLoadingData()
  func updateDetails()
  func failedLoadingDetails(message: String)
}

class ProposalDetailsViewModel {
  
  unowned let viewController: ProposalDetailsViewControllerProtocol
  let votingStore: VotingAPIStore
  var proposalDetails: ProposalDetails?
  var proposal: Proposal
  var id: String
  
  init(viewController: ProposalDetailsViewControllerProtocol,
       votingStore: VotingAPIStore = VotingAPIStore(),
       proposal: Proposal) {
    self.viewController = viewController
    self.votingStore = votingStore
    self.id = "\(proposal.id)"
    self.proposal = proposal
  }
  
  func viewDidLoad() {
    viewController.isLoadingData()
    getProposalDetails(id: id)
  }
  
  private func getProposalDetails(id: String) {
    votingStore.getProposalDetails(id: id) { [weak self] result in
      self?.viewController.finishedLoadingData()
      switch result {
      case .success(let proposalDetailsGet):
        self?.proposalDetails = proposalDetailsGet.result
        self?.viewController.updateDetails()
      case .failure(let error):
        print(error.localizedDescription)
        self?.viewController.failedLoadingDetails(message: "Loading failed, please try again.")
      }
    }
  }
}
