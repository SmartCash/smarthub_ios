//
//  AccountSelectionTableViewCell.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 19/10/18.
//  Copyright © 2018 Erick Vavretchek. All rights reserved.
//

import UIKit

class AccountSelectionTableViewCell: UITableViewCell {
  
  @IBOutlet weak var accountWalletImageView: UIImageView!
  @IBOutlet weak var accountBalanceLabel: UILabel!
  @IBOutlet weak var accountNameLabel: UILabel!
  @IBOutlet weak var accountAddressLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configure(account: Wallet, row: Int, selectedAccount: String?, willSetGlobalSelectedAccount: Bool) {
    accountBalanceLabel.text = "Σ \(account.balance)"
    accountNameLabel.text = account.displayName.uppercased()
    accountAddressLabel.text = account.address
    let walletImageName = "icon_wallet_\(row%7+1)"
    accountWalletImageView.image = UIImage(named: walletImageName)
    if let selectedAccount = selectedAccount {
      if selectedAccount == account.address {
        self.accessoryType = .checkmark
      } else {
        self.accessoryType = .none
      }
    } else if row == 0 && willSetGlobalSelectedAccount {
      self.accessoryType = .checkmark
      UserDefaults.standard.set(account.address, forKey: "selected_account")
    } else {
      self.accessoryType = .none
    }
  }
}
