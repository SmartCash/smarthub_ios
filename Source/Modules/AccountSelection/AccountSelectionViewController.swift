//
//  AccountSelectionViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 19/10/18.
//  Copyright © 2018 Erick Vavretchek. All rights reserved.
//

import UIKit

protocol PassSelectedAccountDelegate {
  func receiveSelectedAccount(account: Wallet)
}

class AccountSelectionViewController: UITableViewController {
  
  var accounts = [Wallet]()
  var selectedAccount: String?
  var delegate: PassSelectedAccountDelegate?
  var willSetGlobalSelectedAccount = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Select Account"
    
    if let myWalllets = MyDetails.shared.allWallets {
      accounts = myWalllets
      if willSetGlobalSelectedAccount {
        selectedAccount = getSelectedAccount()
      }
      tableView.reloadData()
    }
    
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
    }
  }
  
  func getSelectedAccount() -> String? {
    return UserDefaults.standard.string(forKey: "selected_account")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return accounts.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? AccountSelectionTableViewCell {
      cell.configure(account: accounts[indexPath.row], row: indexPath.row, selectedAccount: selectedAccount, willSetGlobalSelectedAccount: willSetGlobalSelectedAccount)
      return cell
    }
    return UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if willSetGlobalSelectedAccount {
      UserDefaults.standard.set(accounts[indexPath.row].address, forKey: "selected_account")
    }
    selectedAccount = accounts[indexPath.row].address
    tableView.reloadData()
    delegate?.receiveSelectedAccount(account: accounts[indexPath.row])
    if navigationController?.topViewController == self {
      navigationController?.popViewController(animated: true)
      dismiss(animated: true, completion: nil)
    } else {
      dismiss(animated: true, completion: nil)
    }
  }
}
