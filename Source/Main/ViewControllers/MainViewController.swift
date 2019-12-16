//
//  MainViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 7/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import ToastSwiftFramework

class MainViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var balanceLabel: UILabel!
  
  var viewModel: MainViewModel!
  var loadingView: UIView = LoadingView.make()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareNavigationController()
    
    
    
    viewModel = MainViewModel(viewController: self)
    viewModel.viewDidLoad()
    
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
    
    tableView.dataSource = self
    tableView.delegate = self
    
    NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "PRIVATE_KEY_IMPORTED"), object: nil, queue: nil) { [weak self] notification in
      guard
        let userInfo = notification.userInfo,
        let accountName  = userInfo["accountName"] as? String
        else {
          print("No userInfo found in notification")
          return
      }
      
      self?.update()
      self?.view.makeToast("Account \(accountName) was successfully imported", duration: 3.0, position: .center)
    }
  }
  
  
  @objc func refresh() {
    let smartcashAPIStore = SmartcashAPIStore()
    smartcashAPIStore.getWallet(force: true) { [weak self] result in
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      self?.update()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Analytics.setScreenName("Wallets", screenClass: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    update()
  }
  
  // MARK: Actions
  
  @IBAction func actionButtonAction(_ sender: Any) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let logoffAction = UIAlertAction(title: "Log Off", style: .destructive) { [weak self] _ in
      self?.viewModel.logOff()
    }
    let refreshAction = UIAlertAction(title: "Refresh", style: .default) { [weak self] _ in
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      self?.refresh()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(logoffAction)
    alertController.addAction(cancelAction)
    alertController.addAction(refreshAction)
    present(alertController, animated: true, completion: nil)
  }
  
  // MARK: Private
  
  private func prepareNavigationController() {
    title = "Overview"
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .always
    }
  }
  
  func displayTransactions(index: Int) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let transactionsViewController = storyboard.instantiateViewController(withIdentifier: "TransactionsViewController") as? TransactionsViewController {
      transactionsViewController.transactions = MyDetails.shared.allWallets?[index].transactions
      transactionsViewController.title = MyDetails.shared.allWallets?[index].displayName
      navigationController?.pushViewController(transactionsViewController, animated: true)
    }
  }
}

// MARK: MainViewControllerProtocol

extension MainViewController: MainViewControllerProtocol {
  func displayError(message: String) {
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  func update() {
    if let myWallets = MyDetails.shared.allWallets {
      let amount = myWallets.map { $0.balance }.reduce(0, +)
      let roundAmount = String(NumberFormatter.localizedString(from: NSNumber(value: Double(round(1000000*amount)/1000000)), number: NumberFormatter.Style.decimal))
      balanceLabel.text = "𝝨 \(roundAmount)"
      tableView.reloadData()
    }
  }
  
  func logOffCompleted() {
    (UIApplication.shared.delegate as? AppDelegate)?.appScreenSwitcher.determineAndSetAppFirstScreen()
  }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return MyDetails.shared.allWallets?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell", for: indexPath) as? AccountTableViewCell {
      cell.configure(wallet: MyDetails.shared.allWallets![indexPath.row], row: indexPath.row)
      cell.onCopyAddressClicked = { [weak self] in
        self?.tabBarController?.view.makeToast("Address copied to clipboard")
      }
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    displayTransactions(index: indexPath.row)
  }
}
