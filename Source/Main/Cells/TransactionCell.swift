//
//  TransactionCell.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 21/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
  
  @IBOutlet weak var amountLabel: UILabel!
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var directionImageView: UIImageView!
  @IBOutlet weak var directionLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    directionLabel.layer.cornerRadius = 10
    directionLabel.clipsToBounds = true
    
  }
  
  func configure(transaction: Transaction) {
    
  
    if transaction.direction == "Sent" {
      directionImageView.image = UIImage(named: "transaction_paid_arrow")
      directionImageView.tintColor = Color.transactionPaid
      directionLabel.text = "PAID"
      directionLabel.backgroundColor = Color.transactionPaid
    } else {
      directionImageView.image = UIImage(named: "transaction_received_arrow")
      directionImageView.tintColor = Color.transactionReceived
      directionLabel.text = "RECEIVED"
      directionLabel.backgroundColor = Color.transactionReceived

    }
    
    amountLabel.text = "\(transaction.amount) SMART"
    dateLabel.text = transaction.timestamp
    statusLabel.text = transaction.isPending ? "Pending" : ""
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
