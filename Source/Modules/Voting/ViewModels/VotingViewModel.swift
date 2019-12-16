//
//  VotingViewModel.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 17/10/18.
//  Copyright © 2018 Erick Vavretchek. All rights reserved.
//

import Foundation

protocol VotingViewControllerProtocol: class, LoadingCapable {
  func refreshTableView()
  func stopTableRefresh()
  func scrollTableToTop()
  func clearSearchBox()
}

class VotingViewModel {
  
  unowned let viewController: VotingViewControllerProtocol
  let votingStore: VotingAPIStore
  private var allProposals = [Proposal]()
  var filteredProposals = [Proposal]()

  init(viewController: VotingViewControllerProtocol, votingStore: VotingAPIStore = VotingAPIStore()) {
    self.viewController = viewController
    self.votingStore = votingStore
  }
  
  func getProposals(_ index: Int, _ searchText: String) {
    viewController.showLoadingView(message: "Loading Proposals...")
    votingStore.getProposals { [weak self] (result) in
      self?.viewController.hideLoadingView()
      self?.viewController.stopTableRefresh()
      switch result {
      case .success(let proposalsGet):
        self?.allProposals = proposalsGet.result
        self?.filterProposals(by: searchText, index)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
//  func filterProposals(_ index: Int) {
//    switch index {
//    case 0: filteredProposals = allProposals.filter {$0.status == "Open"}
//    case 1: filteredProposals = allProposals.filter {$0.status == "Funds Allocated"}
//    case 2: filteredProposals = allProposals.filter {$0.status == "Completed"}
//    case 3: filteredProposals = allProposals.filter {$0.status == "Not Funded"}
//    default: return
//    }
//    viewController.refreshTableView()
//    viewController.scrollTableToTop()
//    viewController.clearSearchBox()
//  }
  
  func filterProposals(by text: String, _ index: Int) {
    switch index {
    case 0: filteredProposals = allProposals.filter {$0.status == "Open"}
    case 1: filteredProposals = allProposals.filter {$0.status == "Funds Allocated"}
    case 2: filteredProposals = allProposals.filter {$0.status == "Completed"}
    case 3: filteredProposals = allProposals.filter {$0.status == "Not Funded"}
    default: return
    }
    if (!text.isEmpty) {
      filteredProposals = filteredProposals.filter { $0.title.lowercased().contains(text.lowercased()) || $0.owner.lowercased().contains(text.lowercased())}
    }
    viewController.refreshTableView()
    viewController.scrollTableToTop()
  }
}
