//
//  ProposalDetailViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 23/10/18.
//  Copyright © 2018 Erick Vavretchek. All rights reserved.
//

import UIKit

class ProposalDetailViewController: UIViewController {
  
  // MARK: Outlets
  @IBOutlet weak var progressBar: UIProgressView!
  @IBOutlet weak var textView: UITextView!
  
  @IBOutlet weak var spinnerView: UIView!
  @IBOutlet weak var contentView: UIView!
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var ownerLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var questionImageView: UIImageView!
  
  @IBOutlet weak var amountsView: UIView!
  @IBOutlet weak var amountSMARTLabel: UILabel!
  @IBOutlet weak var amountUSDLabel: UILabel!
  @IBOutlet weak var amountBitcoinLabel: UILabel!
  
  @IBOutlet weak var votesImageView: UIImageView!
  
  @IBOutlet weak var votingPercentView: UIView!
  @IBOutlet weak var thumbsUpImageView: UIImageView!
  @IBOutlet weak var yesPercentLabel: UILabel!
  @IBOutlet weak var yesVoteLabel: UILabel!
  @IBOutlet weak var yesProgressView: UIProgressView!
  @IBOutlet weak var thumbsDownImageView: UIImageView!
  @IBOutlet weak var noPercentLabel: UILabel!
  @IBOutlet weak var noVoteLabel: UILabel!
  @IBOutlet weak var noProgressView: UIProgressView!
  @IBOutlet weak var thumbsTwoImageView: UIImageView!
  @IBOutlet weak var abstainPercentLabel: UILabel!
  @IBOutlet weak var abstainVoteLabel: UILabel!
  @IBOutlet weak var abstainProgressView: UIProgressView!

  @IBOutlet weak var votingDeadlineImageView: UIImageView!
  
  @IBOutlet weak var votingDeadlineView: UIView!
  @IBOutlet weak var deadlineProgressView: UIProgressView!
  @IBOutlet weak var deadlineDateLabel: UILabel!
  @IBOutlet weak var deadlineCountdownLabel: UILabel!
  @IBOutlet weak var votingDeadlineBlueView: UIView!
  
  @IBOutlet weak var summaryView: UIView!
  @IBOutlet weak var summaryLabel: UILabel!
  
  @IBOutlet weak var descriptionTextView: UITextView!
  
  @IBOutlet weak var castVoteButton: UIButton!
  
  
  var viewModel: ProposalDetailsViewModel!
  var details: ProposalDetails?
  var openToVote: Bool = false
  
  
  // MARK: UIViewController
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.viewDidLoad()
//    progressBar.layer.cornerRadius = 0.75
//    progressBar.clipsToBounds = true
    
    prepareUIElements()
    prepareNavigationController()
  }
  
  // MARK: Actions
  @IBAction func viewDiscussionAction(_ sender: Any) {
    guard let proposal = viewModel.proposalDetails else { return }
    UIApplication.shared.openURL(NSURL(string:"https://vote.smartcash.cc/Proposal/Details/\(proposal.url)")! as URL)

//    if let link = URL(string: "https://vote.smartcash.cc/Proposal/Details/\(proposal.url)") {
//      UIApplication.shared.open(link)
//    }
  }
  
  @IBAction func voteAction(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Voting", bundle: nil)
    if let voteViewController = storyboard.instantiateViewController(withIdentifier: "VoteViewController") as? VoteViewController {
      let voteViewModel = VoteViewModel(viewController: voteViewController, proposal: viewModel.proposal)
      voteViewController.viewModel = voteViewModel
      navigationController?.pushViewController(voteViewController, animated: true)
    }
  }
  
  @IBAction func votingAuditAction(_ sender: Any) {
    viewDiscussionAction("")
  }
  // MARK: Private
  private func prepareUIElements() {
    statusLabel.layer.cornerRadius = 10
    statusLabel.clipsToBounds = true
    
    questionImageView.tintColor = Color.questionMark
    
    amountsView.layer.cornerRadius = 5
    amountsView.clipsToBounds = true
    
    votesImageView.tintColor = Color.questionMark
    
    
    votingPercentView.layer.cornerRadius = 5
    votingPercentView.clipsToBounds = true
    thumbsUpImageView.tintColor = Color.thumbsUp
    thumbsDownImageView.tintColor = Color.thumbsDown
    thumbsTwoImageView.tintColor = Color.thumbsTwo
    
    votingDeadlineImageView.tintColor = Color.questionMark
    
    votingDeadlineView.layer.cornerRadius = 5
    votingDeadlineView.clipsToBounds = true
    votingDeadlineBlueView.layer.cornerRadius = 5
    votingDeadlineBlueView.clipsToBounds = true
    
    summaryView.layer.cornerRadius = 5
    summaryView.clipsToBounds = true
    
    castVoteButton.isHidden = !openToVote
    
  }
  
  private func prepareNavigationController() {
    title = "Proposal Details"
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
    }
  }
  
  private func doubleToString(_ decimals: Int, amount: Double, style: NumberFormatter.Style = .decimal) -> String {
    let multiplier = pow(10.0, Double(decimals))
    return String(NumberFormatter.localizedString(from: NSNumber(value: Double(round(multiplier*amount)/multiplier)), number: style))
    
    
    //    let formatter = NumberFormatter()
    //    formatter.numberStyle = NumberFormatter.Style.decimal
    //    formatter.roundingMode = NumberFormatter.RoundingMode.halfUp
    //    formatter.maximumFractionDigits = decimals
    //    formatter.currencyGroupingSeparator = ","
    //    formatter.groupingSeparator = ","
    //    formatter.groupingSize = 3
    //    formatter.alwaysShowsDecimalSeparator = false
    //
    //    let roundedValue = formatter.string(from: NSNumber(value: amount))
    //    return String(describing: roundedValue!) // prints Optional("0.684")
  }
  
  private func formatDate(_ dateString: String) -> String {
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
  
  private func getDateFromString(dateString: String) -> Date {
    let dateFormatter = DateFormatter()
    let tempLocale = dateFormatter.locale // save locale temporarily
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return dateFormatter.date(from: dateString)!
  }
  
  private func populateVotingDeadline(votingDeadline: String) {
    let votingDeadlineDate = getDateFromString(dateString: votingDeadline)
    guard let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) else { return }
    let difference = Calendar.current.dateComponents([.day], from: today, to: votingDeadlineDate)
    guard let days = difference.day else { return }
    let ess = days > 1 ? "s" : ""
    deadlineCountdownLabel.text = days >= 0 ? "\(days) day\(ess) left" : "Expired"
  }
  
  private func populateVotindDealineProgressBar(creationDate: String, votingDeadline: String) {
    let dateFrom = getDateFromString(dateString: creationDate)
    let dateTo = getDateFromString(dateString: votingDeadline)
    
    var difference = Calendar.current.dateComponents([.day], from: dateFrom, to: dateTo)
    guard let total = difference.day else { return }
    
    guard let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) else { return }
    difference = Calendar.current.dateComponents([.day], from: today, to: dateTo)
    guard let remaining = difference.day else { return }
    
    let percent = Float(total - remaining)/Float(total)
    deadlineProgressView.setProgress(percent, animated: false)
  }
}

extension ProposalDetailViewController: ProposalDetailsViewControllerProtocol {
  func isLoadingData() {
    spinnerView.isHidden = false
    contentView.isHidden = true
  }
  
  func finishedLoadingData() {
    spinnerView.isHidden = true
    contentView.isHidden = false
  }
  
  func updateDetails() {

    guard let proposal = viewModel.proposalDetails else { return }
    
    titleLabel.text = proposal.title
    statusLabel.text = proposal.status
    if proposal.status != "Open" && proposal.status != "Funds Allocated" {
      if proposal.status == "Not Funded" {
        statusLabel.backgroundColor = Color.thumbsDown
      } else {
        statusLabel.backgroundColor = Color.smartBlack
      }
    }
    ownerLabel.text = proposal.owner
    dateLabel.text = formatDate(proposal.createdDate)
    
    amountSMARTLabel.text = doubleToString(0, amount: proposal.amountSMART)
    amountUSDLabel.text = doubleToString(0, amount: proposal.amountUSD)
    amountBitcoinLabel.text = doubleToString(6, amount: proposal.amountBTC)
    
    
    yesPercentLabel.text = "\(doubleToString(2, amount: proposal.percentYes))%"
    yesVoteLabel.text = doubleToString(0, amount: proposal.voteYes)
    yesProgressView.setProgress(Float(proposal.percentYes/100), animated: false)
    
    noPercentLabel.text = "\(doubleToString(2, amount: proposal.percentNo))%"
    noVoteLabel.text = doubleToString(0, amount: proposal.voteNo)
    noProgressView.setProgress(Float(proposal.percentNo/100), animated: false)
    
    abstainPercentLabel.text = "\(doubleToString(2, amount: proposal.percentAbstain))%"
    abstainVoteLabel.text = doubleToString(0, amount: proposal.voteAbstain)
    abstainProgressView.setProgress(Float(proposal.percentAbstain/100), animated: false)
    
    deadlineDateLabel.text = formatDate(proposal.votingDeadline)
    populateVotingDeadline(votingDeadline: proposal.votingDeadline)
    populateVotindDealineProgressBar(creationDate: proposal.createdDate, votingDeadline: proposal.votingDeadline)
    
    summaryLabel.text = viewModel.proposalDetails?.summary
    
    if let attString = viewModel.proposalDetails?.description.htmlAttributedString() {
      descriptionTextView.attributedText = attString.setFontFace(font: UIFont.systemFont(ofSize: 16.0), color: Color.descriptionText)
    }
    
    if proposal.status != "Open" {
      castVoteButton.isHidden = true
    }
  }
  
  func failedLoadingDetails(message: String) {
    
  }
  
  
}
