//
//  VoteViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 25/10/18.
//  Copyright © 2018 Erick Vavretchek. All rights reserved.
//

import UIKit

class VoteViewController: UIViewController {
  
  
  // MARK: Outlets
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var accountIconImageView: UIImageView!
  @IBOutlet weak var accountBalanceLabel: UILabel!
  @IBOutlet weak var accountNameLabel: UILabel!
  @IBOutlet weak var accountAddressLabel: UILabel!
  @IBOutlet weak var chevronImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var thumbsUpImageView: UIImageView!
  @IBOutlet weak var abstainImageView: UIImageView!
  @IBOutlet weak var thumbsDownImageView: UIImageView!
  @IBOutlet weak var yesView: UIView!
  @IBOutlet weak var abstainView: UIView!
  @IBOutlet weak var noView: UIView!
  @IBOutlet weak var voteSelectionStack: UIStackView!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var voteButton: UIButton!
  
  // MARK: Declaration
  var viewModel: VoteViewModel!
  var accounts = [Wallet]()
  var selectedAccount: String?
  var buttonAnimatedView: UIView!
  var selectedVoteView: UIView!
  
  // MARK: UIViewController
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Vote"
    prepareUIElements()
    prepareNavigationController()
    registerForKeyboardNotifications()
    viewModel.viewDidLoad()
    
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    selectedAccount = UserDefaults.standard.string(forKey: "selected_account")
    if let myWalllets = MyDetails.shared.allWallets {
      accounts = myWalllets
      setInitialSelectedAccount()
    }
  }
  
  // MARK: Actions
  @IBAction func selectAccountAction(_ sender: Any) {
    let storyboard = UIStoryboard(name: "AccountSelection", bundle: nil)
    let accountSelectionViewController = storyboard.instantiateInitialViewController() as! AccountSelectionViewController
    navigationController?.pushViewController(accountSelectionViewController, animated: true)
  }
  
  @IBAction func yesAction(_ sender: Any) {
    centerButtonAnimatedView(on: yesView, color: Color.thumbsUp)
  }
  
  @IBAction func abstainAction(_ sender: Any) {
    centerButtonAnimatedView(on: abstainView, color: Color.thumbsTwo)
  }
  
  @IBAction func noAction(_ sender: Any) {
    centerButtonAnimatedView(on: noView, color: Color.thumbsDown)
  }
  
  @IBAction func voteAction(_ sender: Any) {
    var voteType = ""
    switch selectedVoteView {
    case yesView:
      voteType = "YES"
    case noView:
      voteType = "NO"
    case abstainView:
      voteType = "Abstain"
    default:
      displayError(message: "Select your vote!")
      return
    }
    
    guard
      let userKey = passwordTextField.text,
      userKey != "",
      let from = selectedAccount
      else {
        displayError(message: "Enter your password!")
        return
    }
    
    viewModel.castVote(address: from, voteType: voteType, userKey: userKey)
    
  }
  
  @IBAction func containerViewTapAction(_ sender: Any) {
    view.endEditing(true)
  }
  
  // MARK: Private
  private func prepareUIElements() {
    chevronImageView.tintColor = Color.chevron
    thumbsUpImageView.tintColor = Color.thumbsUp
    thumbsDownImageView.tintColor = Color.thumbsDown
    abstainImageView.tintColor = Color.thumbsTwo
    voteButton.layer.cornerRadius = 5
    voteButton.clipsToBounds = true
    spinner.isHidden = true
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
      self?.configureButtonAnimatedView()
    }
  }
  
  private func prepareNavigationController() {
    title = "Vote"
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
    }
  }
  
  private func centerButtonAnimatedView(on view: UIView, color: UIColor) {
    selectedVoteView = view
    buttonAnimatedView.isHidden = false
    UIView.animate(withDuration: 0.33) { [weak self] in
      let point = CGPoint(x: view.center.x, y: view.center.y + 20)
      self?.buttonAnimatedView.center = point
      self?.buttonAnimatedView.backgroundColor = color
    }
  }
  
  
  
  func configureButtonAnimatedView() {
    buttonAnimatedView = UIView(frame: CGRect(x: 0, y: 0, width: abstainView.frame.width, height: 4))
    buttonAnimatedView.backgroundColor = Color.thumbsTwo
    buttonAnimatedView.layer.cornerRadius = 2
    buttonAnimatedView.clipsToBounds = true
    voteSelectionStack.addSubview(buttonAnimatedView)
    //    buttonsContainerView.sendSubview(toBack: buttonAnimatedView)
    let point = CGPoint(x: abstainView.center.x, y: abstainView.center.y + 20)
    buttonAnimatedView.center = point
//    selectedInStack = abstainView
    buttonAnimatedView.isHidden = true
  }
  
  func setInitialSelectedAccount() {
    if let selectedAccount = selectedAccount {
      for i in 0..<accounts.count {
        if accounts[i].address == selectedAccount {
          accountBalanceLabel.text = "Σ \(accounts[i].balance)"
          accountAddressLabel.text = accounts[i].address
//          smartAddressButton.setTitle(accounts[i].address, for: .normal)
          accountNameLabel.text = accounts[i].displayName.uppercased()
          let walletImageName = "icon_wallet_\(i%7+1)"
          accountIconImageView.image = UIImage(named: walletImageName)
        }
      }
    } else {
      accountBalanceLabel.text = "Σ \(accounts[0].balance)"
      accountAddressLabel.text = accounts[0].address
//      smartAddressButton.setTitle(accounts[0].address, for: .normal)
      accountNameLabel.text = accounts[0].displayName.uppercased()
      let walletImageName = "icon_wallet_\(0%7+1)"
      accountIconImageView.image = UIImage(named: walletImageName)
      selectedAccount = accounts[0].address
    }
  }
  
  

  
}

extension VoteViewController: VoteViewControllerProtocol {
  func populateData(proposal: Proposal) {
    titleLabel.text = proposal.title
  }
  
  func displayError(message: String) {
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(okAction)
    passwordTextField.text = ""
    present(alertController, animated: true, completion: nil)
  }
  
  func votedSuccessfully(message: String) {
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
      self?.navigationController?.popViewController(animated: true)
    }
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  func startLoading() {
    spinner.isHidden = false
    voteButton.setTitle("", for: .normal)
  }
  func stopLoading() {
    spinner.isHidden = true
    voteButton.setTitle("VOTE", for: .normal)
  }
}

extension VoteViewController {
  
  func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardDidShow(notification:)),
                                           name: UIResponder.keyboardDidShowNotification,
                                           object: nil)
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide(notification:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }
  
  @objc func keyboardDidShow(notification: NSNotification) {
    guard let keyboardSize = notification.keyboardFrame()?.size else { return }
    
    let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets
    
    var frame = view.frame
    frame.size.height -= keyboardSize.height
    
    if let field = passwordTextField, !frame.contains(field.frame.origin) {
      scrollView.scrollRectToVisible(field.frame, animated: true)
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    scrollView.contentInset = UIEdgeInsets.zero
    scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
  }
}
