//
//  TransactionsViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 21/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class TransactionsViewController: UITableViewController {
  
  
  var transactions: [Transaction]!
  var transactionDetailsViewController: TransactionDetailsViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 140
    
    refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
    }
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Analytics.setScreenName("Transactions", screenClass: nil)
  }
  
  @objc func refresh() {
    let smartcashAPIStore = SmartcashAPIStore()
    smartcashAPIStore.getWallet(force: true) { [weak self] result in
      self?.refreshControl?.endRefreshing()
      self?.tableView.reloadData()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return transactions.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as? TransactionCell {
      cell.configure(transaction: transactions[indexPath.row])
      return cell
    }
    return UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 72
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    tableView.deselectRow(at: indexPath, animated: false)
    transactionDetailsViewController = TransactionDetailsViewController(nibName: "TransactionDetailsView", bundle: nil)
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let viewWidth = screenWidth - 75
    let viewHeight = CGFloat(180.0)
    let viewX = screenWidth / 2 - viewWidth / 2
    let viewY = screenHeight / 2 - viewHeight / 2
    transactionDetailsViewController?.preferredContentSize = CGSize(width: viewWidth, height: viewHeight)
    transactionDetailsViewController?.modalPresentationStyle = .popover
    transactionDetailsViewController?.transaction = transactions[indexPath.row]
    let popover = transactionDetailsViewController?.popoverPresentationController!
    popover?.delegate = self
    popover?.permittedArrowDirections = .init(rawValue: 0)
    popover?.sourceView = view.superview
    popover?.sourceRect = CGRect.init(x: viewX, y: viewY, width: viewWidth, height: viewHeight)
    present(transactionDetailsViewController!, animated: true, completion: nil)
  }
}

extension TransactionsViewController: UIPopoverPresentationControllerDelegate {
  func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    return .none
  }
  
  func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
    view.alpha = 0.2
  }
  
  func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    view.alpha = 1
  }
  
}
