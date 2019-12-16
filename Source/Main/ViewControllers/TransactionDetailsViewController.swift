//
//  TransactionDetailsViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 1/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class TransactionDetailsViewController: UIViewController {
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var directionImageVIew: UIImageView!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var txIdLabel: UILabel!
  @IBOutlet weak var footerView: UIView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  
  var transaction: Transaction!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    containerView.layer.borderWidth = 1
    containerView.layer.borderColor = SmartcashKit.Colors.black.cgColor
    containerView.clipsToBounds = true
    containerView.layer.cornerRadius = 5
    
    if transaction.direction == "Sent" {
      directionImageVIew.image = UIImage(named: "transaction_paid_arrow")
      directionImageVIew.tintColor = Color.transactionPaid
      amountLabel.text = "Sent \(transaction.amount) SMART"
    } else {
      directionImageVIew.image = UIImage(named: "transaction_received_arrow")
      directionImageVIew.tintColor = Color.transactionReceived
      amountLabel.text = "Received \(transaction.amount) SMART"
    }
    
 
    addressLabel.text = transaction.direction == "Sent" ? "to \(transaction.toAddress)" : ""
    dateLabel.text = transaction.timestamp
    statusLabel.text = transaction.isPending ? "PENDING" : "COMPLETED"
    footerView.backgroundColor = transaction.direction == "Sent" ? Color.transactionPaid : Color.transactionReceived
    txIdLabel.text = transaction.hash
    txIdLabel.textColor = transaction.direction == "Sent" ? Color.transactionPaid : Color.transactionReceived
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Analytics.setScreenName("Transaction Details", screenClass: nil)
  }
  
  @IBAction func transactionTap() {
    UIApplication.shared.openURL(URL(string: "https://explorer.smartcash.cc/tx/\(transaction.hash)")!)
  }
}
