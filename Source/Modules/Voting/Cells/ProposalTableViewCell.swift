//
//  ProposalTableViewCell.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 16/10/18.
//  Copyright © 2018 Erick Vavretchek. All rights reserved.
//

import UIKit

class ProposalTableViewCell: UITableViewCell {

  @IBOutlet weak var titleTextLabel: UILabel!
  @IBOutlet weak var statusTextLabel: UILabel!
  @IBOutlet weak var ownerTextLabel: UILabel!
  @IBOutlet weak var dateTextLabel: UILabel!
  @IBOutlet weak var yesLabel: UILabel!
  @IBOutlet weak var noLabel: UILabel!
  @IBOutlet weak var abstainLabel: UILabel!
  @IBOutlet weak var fundsLabel: UILabel!
  @IBOutlet weak var voteButton: UIButton!
  @IBOutlet weak var viewButton: UIButton!
  
//  var id: String!
  var proposal: Proposal!
  typealias OnViewProposalClicked = (Proposal) -> ()
  var onViewProposalClicked: OnViewProposalClicked?
  
  typealias OnVoteProposalClicked = (Proposal) -> ()
  var onVoteProposalClicked: OnVoteProposalClicked?
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      statusTextLabel.layer.cornerRadius = 10
      statusTextLabel.clipsToBounds = true
    
    voteButton.layer.cornerRadius = 4
    voteButton.clipsToBounds = true
    
    viewButton.layer.cornerRadius = 4
    viewButton.clipsToBounds = true
    }

  // MARK: Actions
  @IBAction func viewProposalAction(_ sender: Any) {
    onViewProposalClicked?(proposal)
  }
  
  @IBAction func voteProposalAction(_ sender: Any) {
    onVoteProposalClicked?(proposal)
  }
  
  func configure(proposal: Proposal) {
    self.proposal = proposal

    
    switch proposal.status {
    case "Not Funded":
      statusTextLabel.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0, blue: 0, alpha: 1)
    case "Open", "Funds Allocated":
      statusTextLabel.backgroundColor = #colorLiteral(red: 0.5411764706, green: 0.7647058824, blue: 0.2901960784, alpha: 1)
    default:
      statusTextLabel.backgroundColor = Color.smartBlack
    }
    
    if proposal.status == "Open" {
      voteButton.isHidden = false
    } else {
      voteButton.isHidden = true
    }
    titleTextLabel.text = proposal.title
    statusTextLabel.text = proposal.status
    ownerTextLabel.text = proposal.owner
    dateTextLabel.text = formatDate(proposal.createdDate)
    yesLabel.text = String(Double(round(100*proposal.percentYes)/100))+"%"
    noLabel.text = String(Double(round(100*proposal.percentNo)/100))+"%"
    abstainLabel.text = String(Double(round(100*proposal.percentAbstain)/100))+"%"
    fundsLabel.text = String(NumberFormatter.localizedString(from: NSNumber(value: Double(round(1000000*proposal.amountSMART)/1000000)), number: NumberFormatter.Style.decimal))
    
    

  }
  
  func formatDate(_ dateString: String) -> String {
    let dateFormatter = DateFormatter()
    let tempLocale = dateFormatter.locale // save locale temporarily
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    let date = dateFormatter.date(from: dateString)!
    dateFormatter.dateFormat = "d MMM, yyyy - h:mm a"
    dateFormatter.locale = tempLocale // reset the locale
    let dateString = dateFormatter.string(from: date.toLocalTime())
    return dateString
  }

}




