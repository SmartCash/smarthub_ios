//
//  AccountTableViewCell.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 17/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import ToastSwiftFramework

class AccountTableViewCell: UITableViewCell {
  
  @IBOutlet weak var cellContainerView: UIView!
  @IBOutlet weak var accountNameLabel: UILabel!
  @IBOutlet weak var totalBalanceLabel: UILabel!
  @IBOutlet weak var accountAddressLabel: UILabel!
  @IBOutlet weak var walletIconImageView: UIImageView!
  
  var address: String?
  typealias OnCopyAddressClicked = () -> ()
  var onCopyAddressClicked: OnCopyAddressClicked?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
//    cellContainerView.layer.borderWidth = 1
//    cellContainerView.layer.borderColor = SmartcashKit.Colors.black.cgColor
    cellContainerView.layer.cornerRadius = 5
//    cellContainerView.clipsToBounds = true
    
    cellContainerView.layer.cornerRadius = 2
    cellContainerView.layer.shadowColor = Color.smartBlack.cgColor
    cellContainerView.layer.shadowOffset = CGSize(width: 0.5, height: 2.0) //CGSizeMake(0.5, 4.0); //Here your control your spread
    cellContainerView.layer.shadowOpacity = 0.5
    cellContainerView.layer.shadowRadius = 3.0 //Here your control your blur
    
    walletIconImageView.tintColor = Color.copyContentIcon
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func configure(wallet: Wallet, row: Int) {
    accountNameLabel.text = wallet.displayName.uppercased()
    let roundAmount = String(NumberFormatter.localizedString(from: NSNumber(value: Double(round(10000*wallet.balance)/10000)), number: NumberFormatter.Style.decimal))
    totalBalanceLabel.text = "𝝨 \(roundAmount)"
    accountAddressLabel.text = wallet.address
    address = wallet.address
    let walletImageName = "icon_wallet_\(row%7+1)"
    walletIconImageView.image = UIImage(named: walletImageName)
  }
  
  @IBAction func copyAddressAction(_ sender: Any) {
    if let address = address {
      UIPasteboard.general.string = address
      onCopyAddressClicked?()
      print(address)
    }
  }
}
