//
//  VotingViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 16/10/18.
//  Copyright © 2018 Erick Vavretchek. All rights reserved.
//

import UIKit

class VotingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var segmentControl: UISegmentedControl!
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel: VotingViewModel!
  var loadingView: UIView = LoadingView.make()
  let refreshControl = UIRefreshControl()
  let searchBarController: UISearchController = UISearchController(searchResultsController: nil)
  var searchText = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = VotingViewModel(viewController: self)
    viewModel.getProposals(segmentControl.selectedSegmentIndex, searchText)
    
    segmentControl.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)

    prepareNavigationController()
    prepareUIElements()
    tableView.delegate = self
    tableView.dataSource = self
}
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
//    tableView.setContentOffset(CGPoint.init(x: 0, y: 44), animated: false)
  }
  
  @objc func segmentSelected(sender: UISegmentedControl) {
    let index = sender.selectedSegmentIndex
    viewModel.filterProposals(by: searchBarController.searchBar.text ?? "", segmentControl.selectedSegmentIndex)
  }
  
  
  private func prepareNavigationController() {
    title = "Voting"
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .always
    }
  }
  
  func prepareUIElements() {
    
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    if #available(iOS 10.0, *) {
      tableView.refreshControl = refreshControl
    } else {
      tableView.addSubview(refreshControl)
    }
    
    for segment in segmentControl.subviews{
      for label in segment.subviews{
        if let labels = label as? UILabel{
          labels.numberOfLines = 0
        }
      }
    }
    
    searchBarController.searchBar.barStyle = .black
    searchBarController.searchBar.delegate = self
    searchBarController.searchBar.placeholder = "Filter"
    searchBarController.searchBar.showsCancelButton = false
    searchBarController.searchBar.tintColor = Color.smartBlack
    
    
//    searchBarController.searchResultsUpdater = self
    if #available(iOS 11.0, *) {
      navigationItem.searchController = searchBarController
      navigationItem.hidesSearchBarWhenScrolling = true
      searchBarController.dimsBackgroundDuringPresentation = false
    } else {
      navigationItem.titleView = searchBarController.searchBar
    }

  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.filteredProposals.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ProposalTableViewCell {
      cell.configure(proposal: viewModel.filteredProposals[indexPath.row])
      
      cell.onViewProposalClicked = { [weak self] proposal in
        let storyboard = UIStoryboard(name: "Voting", bundle: nil)
        if let proposalDetailsViewController = storyboard.instantiateViewController(withIdentifier: "ProposalDetailViewController") as? ProposalDetailViewController {
          let proposalDetailsViewModel = ProposalDetailsViewModel(viewController: proposalDetailsViewController, proposal: proposal)
          proposalDetailsViewController.viewModel = proposalDetailsViewModel
          proposalDetailsViewController.openToVote = proposal.status == "Open"
          self?.navigationController?.pushViewController(proposalDetailsViewController, animated: true)
        }
      }
      
      cell.onVoteProposalClicked = { [weak self] proposal in
        let storyboard = UIStoryboard(name: "Voting", bundle: nil)
        if let voteViewController = storyboard.instantiateViewController(withIdentifier: "VoteViewController") as? VoteViewController {
          let voteViewModel = VoteViewModel(viewController: voteViewController, proposal: proposal)
          voteViewController.viewModel = voteViewModel
          self?.navigationController?.pushViewController(voteViewController, animated: true)
        }
      }
      
      
      return cell
    }
    return UITableViewCell()
  }
  
  @objc func refresh() {
    viewModel.getProposals(segmentControl.selectedSegmentIndex, searchText)
  }
  
}

extension VotingViewController: VotingViewControllerProtocol {
  func refreshTableView() {
    tableView.reloadData()
  }
  
  func stopTableRefresh() {
    refreshControl.endRefreshing()
  }
  
  func scrollTableToTop() {
    if viewModel.filteredProposals.count > 0 {
      tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
  }
  
  func clearSearchBox() {
    searchBarController.searchBar.text = ""
    searchBarController.isActive = false
    
    
  }
}

extension VotingViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.searchText = searchText
    viewModel.filterProposals(by: searchText, segmentControl.selectedSegmentIndex)
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchBarController.isActive = false
    searchBarController.searchBar.text = searchText
  }
}

extension VotingViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
//    viewModel.filterProposals(by: searchText, segmentControl.selectedSegmentIndex)
  }
}
