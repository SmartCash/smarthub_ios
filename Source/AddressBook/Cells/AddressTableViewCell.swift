//
//  AddressTableViewCell.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 8/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

  @IBOutlet weak var userProfileIcon: UIImageView!
  @IBOutlet weak var addressNameLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  
  typealias OnDeleteContact = (Int?) -> ()
  
  var id: Int?
  var onDeleteContact: OnDeleteContact?
  
    override func awakeFromNib() {
        super.awakeFromNib()
      userProfileIcon.tintColor = Color.userProfileIcon
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configure(address: Address, index: Int) {
    id = address.id
    addressLabel.text = address.address
    addressNameLabel.text = address.name
    self.backgroundColor = index % 2 == 0 ? Color.white : Color.addressBookCellBackground
  }
  
  // MARK: Actions
  @IBAction func deleteAction(_ sender: Any) {
    onDeleteContact?(id)
  }
  
}
