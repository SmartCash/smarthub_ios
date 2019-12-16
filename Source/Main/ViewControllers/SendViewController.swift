//
//  SendViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 23/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class SendViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!

  @IBOutlet weak var accountIconImageView: UIImageView!
  @IBOutlet weak var accountBalanceLabel: UILabel!
  @IBOutlet weak var accountNameLabel: UILabel!
  @IBOutlet weak var accountAddressLabel: UILabel!
  @IBOutlet weak var chevronImageView: UIImageView!
  @IBOutlet weak var buttonsContainerView: UIView!
  
  @IBOutlet weak var navigationViewsStack: UIStackView!
  @IBOutlet weak var addressSelectionView: UIView!
  @IBOutlet weak var emailSelectionView: UIView!
  @IBOutlet weak var smsSelectionView: UIView!
  
  @IBOutlet weak var step2AddressView: UIView!
  @IBOutlet weak var step2EmailView: UIView!
  @IBOutlet weak var step2SmsView: UIView!
  
  @IBOutlet weak var stackView: UIStackView!
  
  
  @IBOutlet weak var step1AccountName: UILabel!
  @IBOutlet weak var step1AccountAddress: UILabel!
  
  @IBOutlet weak var step2AddressAddressTextView: UITextField!
  @IBOutlet weak var step3AmountTextView: UITextField!
  @IBOutlet weak var step3PasswordTextField: UITextField!
  
  @IBOutlet weak var dashedView: UIView!
  
  @IBOutlet weak var sendButton: UIButton!
  
  
  var viewModel: SendViewModel!
  var loadingView: UIView = LoadingView.make()
  
  var activeTextField: UITextField?
  var copiedAmount: String?
  
  
  var accounts = [Wallet]()
  var selectedAccount: String?
  var buttonAnimatedView: UIView!
  var selectedModeView: UIView!
  var selectedInStack: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = SendViewModel(viewController: self)
    registerForKeyboardNotifications()
    prepareUIElements()
    prepareNavigationController()
    
    if buttonAnimatedView == nil {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
        self?.configureButtonAnimatedView()
        self?.dashedView.addDashedBorder()
      }
    } else {
      centerButtonAnimatedView(on: selectedModeView ?? addressSelectionView)
      selectedModeView = selectedModeView ?? addressSelectionView
      if selectedModeView == emailSelectionView {
        selectedInStack = step2EmailView
      }
      if selectedModeView == smsSelectionView {
        selectedInStack = step2SmsView
      }
      if selectedModeView == addressSelectionView {
        selectedInStack = step2AddressView
      }
    }
    
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    selectedAccount = UserDefaults.standard.string(forKey: "selected_account")
    if let myWalllets = MyDetails.shared.allWallets {
      accounts = myWalllets
      setInitialSelectedAccount()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Analytics.setScreenName("Send Smart", screenClass: nil)
    
  }
  
  override func viewDidLayoutSubviews() {
    
  }
  
  func configureButtonAnimatedView() {
    buttonAnimatedView = UIView(frame: CGRect(x: 0, y: 0, width: addressSelectionView.frame.width, height: 4))
    buttonAnimatedView.backgroundColor = Color.smartYellow
    buttonAnimatedView.layer.cornerRadius = 2
    buttonAnimatedView.clipsToBounds = true
    navigationViewsStack.addSubview(buttonAnimatedView)
//    buttonsContainerView.sendSubview(toBack: buttonAnimatedView)
    let point = CGPoint(x: addressSelectionView.center.x, y: addressSelectionView.center.y + 20)
    buttonAnimatedView.center = point
    selectedInStack = step2AddressView
    step2EmailView.isHidden = true
    step2SmsView.isHidden = true
  }
  
  private func centerButtonAnimatedView(on view: UIView) {
    UIView.animate(withDuration: 0.33) { [weak self] in
      let point = CGPoint(x: view.center.x, y: view.center.y + 20)
      self?.buttonAnimatedView.center = point
    }
  }
  
  // MARK: Actions
    
  @IBAction func selectAccountAction(_ sender: Any) {
    let storyboard = UIStoryboard(name: "AccountSelection", bundle: nil)
    let accountSelectionViewController = storyboard.instantiateInitialViewController() as! AccountSelectionViewController
    navigationController?.pushViewController(accountSelectionViewController, animated: true)
  }
  
  @IBAction func tapContainerViewAction(_ sender: Any) {
    view.endEditing(true)
  }
  
  @IBAction func addressSelectionAction(_ sender: Any) {
    centerButtonAnimatedView(on: addressSelectionView)
    selectedModeView = addressSelectionView
    displayStep2(with: step2AddressView)
  }
  
  @IBAction func emailSelectionAction(_ sender: Any) {
    centerButtonAnimatedView(on: emailSelectionView)
    selectedModeView = emailSelectionView
    displayStep2(with: step2EmailView)
  }
  @IBAction func smsSelectionAction(_ sender: Any) {
    centerButtonAnimatedView(on: smsSelectionView)
    selectedModeView = smsSelectionView
    displayStep2(with: step2SmsView)
  }
  
  private func displayStep2(with step2View: UIView) {
    if step2View.isHidden {
      UIView.animate(withDuration: 0.33, delay: 0, options: .curveEaseIn, animations: { [weak self] in
        self?.selectedInStack.alpha = 0
        self?.view.layoutIfNeeded()
      }) { finished in
        self.selectedInStack.isHidden = true
        self.selectedInStack.alpha = 1
        UIView.animate(withDuration: 0.33, delay: 0.1, options: .curveEaseIn, animations: { [weak self] in
          step2View.isHidden = false
          self?.view.layoutIfNeeded()
        }) { finished in
          self.selectedInStack = step2View
        }
      }
    }
  }
  
  @IBAction func sendButtonAction(_ sender: Any) {
    
    guard
      let wallets = MyDetails.shared.allWallets,
      let to = step2AddressAddressTextView.text,
      to != "",
      let amountString = step3AmountTextView.text,
      amountString.isDecimal(),
      let userKey = step3PasswordTextField.text,
      userKey != "",
      let from = selectedAccount
      else {
        displayError(message: "Fill all required fields!")
        return
    }


    if to == from {
      displayError(message: "You cannot send SMART to the same address!")
      return
    }
    
    guard let amountDecimal = amountString.toUSDecimal() else {
      displayError(message: "Amount format is wrong!")
      return
    }

    let balance = wallets.filter { $0.address == from}.first?.balance ?? 0.00
    
    if Decimal(balance) > amountDecimal + Decimal(0.001) {
      view.endEditing(true)
      viewModel.sendPayment(from: from, to: to, amount: amountDecimal, userKey: userKey)
      step2AddressAddressTextView.text = ""
      step3AmountTextView.text = ""
      step3PasswordTextField.text = ""
      copiedAmount = nil
      
    } else {
      displayError(message: "Insufficient balance!\nThere is a 0.001 SMART\ntransaction fee included.")
    }
  }

  @IBAction func scanQRButtonAction(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let qRScannerController = storyboard.instantiateViewController(withIdentifier: "QRScannerController") as? QRScannerController {
      qRScannerController.delegate = self
      present(qRScannerController, animated: true, completion: nil)
    }
  }
  
  @IBAction func ownAccountsAction(_ sender: Any) {
    let storyboard = UIStoryboard(name: "AccountSelection", bundle: nil)
    let accountSelectionViewController = storyboard.instantiateInitialViewController() as! AccountSelectionViewController
    accountSelectionViewController.delegate = self
    accountSelectionViewController.willSetGlobalSelectedAccount = false
    accountSelectionViewController.selectedAccount = step2AddressAddressTextView.text
//    let navControl = UINavigationController(rootViewController: accountSelectionViewController)
//    present(accountSelectionViewController, animated: true, completion: nil)
    navigationController?.pushViewController(accountSelectionViewController, animated: true)
  }
  
  @IBAction func addressBookButtonAction() {
    let storyboard = UIStoryboard(name: "AddressBook", bundle: nil)
    if let addressBookNavController = storyboard.instantiateViewController(withIdentifier: "AddressBookViewController") as? UINavigationController {
      if let addressBookViewController = addressBookNavController.viewControllers.first as? AddressBookViewController {
        let addressBookViewModel = AddressBookViewModel(viewController: addressBookViewController, delegate: self)
        addressBookViewController.viewModel = addressBookViewModel
        present(addressBookNavController, animated: true, completion: nil)
      }
    }
  }
  
  // MARK: Private
  
  func prepareUIElements() {
    chevronImageView.tintColor = Color.chevron
    selectedModeView = addressSelectionView
    sendButton.layer.cornerRadius = 5
    sendButton.clipsToBounds = true
    step3AmountTextView.delegate = self
    step3PasswordTextField.delegate = self
  }
  
  private func prepareNavigationController() {
    title = "Send"
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .always
    }
  }
  
  func setInitialSelectedAccount() {
    if let selectedAccount = selectedAccount {
      for i in 0..<accounts.count {
        if accounts[i].address == selectedAccount {
          accountBalanceLabel.text = "Σ \(accounts[i].balance)"
          accountAddressLabel.text = accounts[i].address
          accountNameLabel.text = accounts[i].displayName.uppercased()
          let walletImageName = "icon_wallet_\(i%7+1)"
          accountIconImageView.image = UIImage(named: walletImageName)
          step1AccountName.text = "\(accounts[i].displayName) selected"
          step1AccountAddress.text = accounts[i].address
        }
      }
    } else {
      accountBalanceLabel.text = "Σ \(accounts[0].balance)"
      accountAddressLabel.text = accounts[0].address
      accountNameLabel.text = accounts[0].displayName.uppercased()
      let walletImageName = "icon_wallet_\(0%7+1)"
      accountIconImageView.image = UIImage(named: walletImageName)
      step1AccountName.text = "\(accounts[0].displayName) selected"
      step1AccountAddress.text = accounts[0].address
      selectedAccount = accounts[0].address
    }
  }
}

// MARK: - UIKeyboardNotifications

extension SendViewController {
  
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
    
    if let field = activeTextField, !frame.contains(field.frame.origin) {
      scrollView.scrollRectToVisible(field.frame, animated: true)
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    scrollView.contentInset = UIEdgeInsets.zero
    scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
  }
}

extension SendViewController: QRCodeDelegate {
  func updateQRCode(withAddress address: String) {
    
//    amountTextView.text = nil
//    toAddressTextView.text = nil
//
//
////    var address = "smartcash:SSsnhMAdw9sbGmtEuH51kxkqFfLCj6tnoe?amount=10.00&label=Tips"
    var workAddress = address
//
    guard let index = address.index(of: ":") else {
      step2AddressAddressTextView.text = address
      return
    }
    
    let indexStartOfText = address.index(address.startIndex, offsetBy: 0)
    let indexEndOfText = address.index(address.startIndex, offsetBy: index.encodedOffset + 1)
    let scheme = address[indexStartOfText..<indexEndOfText]
    if scheme == "smartcash:" {
      workAddress = address.replacingOccurrences(of: scheme, with: "smartcash://")
      print(workAddress)
    }
//
////    guard let index2 = workAddress.index(of: "?") else {
////      toAddressTextView.text = address
////      return
////    }
//
    if let index2 = workAddress.index(of: "?") {
      print(index2.encodedOffset)
      workAddress.insert("/", at: index2)
      print(workAddress)
    }

    //    let uri = "smartcash://ShdPFqK7zdyxezEEfY2bv7fqehJTw7CWU6/?amount=22.00&label=GPU%20Mining&message=Hello"
    if let uri = URL(string: workAddress), let address = uri.host {
      step2AddressAddressTextView.text = address
      if let params = uri.params {
        if let amount = params["amount"] {
          step3AmountTextView.text = amount
        }
      }
    } else {
      step2AddressAddressTextView.text = address
    }
  }
}

extension SendViewController: SendViewControllerProtocol {
  func displayError(message: String) {
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  func paymentSent(from: String) {
    tabBarController?.selectedIndex = 0
    
    if let myWallets = MyDetails.shared.allWallets, let sentFromWallet = myWallets.filter({$0.address == from}).first, let selectedAcountIndex = myWallets.index(of: sentFromWallet) {
      if let mainNavController = tabBarController?.selectedViewController as? UINavigationController {
        if mainNavController.viewControllers.count == 2 {
          if let transactionsViewController = mainNavController.viewControllers[1] as? TransactionsViewController {
            transactionsViewController.transactions = sentFromWallet.transactions
            transactionsViewController.tableView.reloadData()
          }
        } else {
          if let mainViewController = mainNavController.viewControllers.first as? MainViewController {
            mainViewController.displayTransactions(index: selectedAcountIndex)
          }
        }
      }
    }
  }
}

extension SendViewController: AddressBookProtocol {
  func didReceive(address: String) {
    step2AddressAddressTextView.text = address
  }
}

extension SendViewController: PassSelectedAccountDelegate {
  func receiveSelectedAccount(account: Wallet) {
    step2AddressAddressTextView.text = account.address
  }
}

extension SendViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard
      textField === step3AmountTextView,
      !string.isEmpty else { return true }
    
    let validCharacterSet = CharacterSet(charactersIn: "01234567890,.")
    if string.trimmingCharacters(in: validCharacterSet).isEmpty {
      return true
    }
    return false
  }
  
  private func scan(value: String) -> Bool {
    let parsedString = value.replacingOccurrences(of: ",", with: ".")
    var decimalValue: Double = 0
    let scanner = Scanner(string: parsedString)
    scanner.scanDouble(&decimalValue)
    return scanner.isAtEnd
  }
}


