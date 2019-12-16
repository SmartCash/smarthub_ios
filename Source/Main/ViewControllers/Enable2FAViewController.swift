//
//  Enable2FAViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 14/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import Kingfisher
import ToastSwiftFramework
import FirebaseAnalytics

class Enable2FAViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var qrCodeImage: UIImageView!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var manualCodeLabel: UILabel!
  @IBOutlet weak var gaCodeTextField: UITextField!
  @IBOutlet weak var enable2FAButton: UIButton!
  
  var viewModel: Enable2FAViewModel!
  var loadingView: UIView = LoadingView.make()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerForKeyboardNotifications()
    viewModel.viewDidLoad()
    
    prepareUIElements()
    
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Analytics.setScreenName("Enable 2FA", screenClass: nil)
  }
  
  // MARK: Actions
  
  @IBAction func enableAction() {
    guard let gaCode = gaCodeTextField.text else {
      displayError(message: "Please enter\nGoogle Authenticator code")
      return
    }
    view.endEditing(true)
    viewModel.enable(gaCode: gaCode)
  }
  
  @IBAction func tapToCopyAction() {
    if let manualCode = viewModel.manualCode {
      UIPasteboard.general.string = manualCode
      view.makeToast("Manual code copied to clipboard", duration: 3.0, position: .center)
    }
  }
  
  // MARK: Private
  
  private func prepareUIElements() {
    
    title = "Enable 2FA"
    
    setSpinnerStatus(isSpinning: true)
    
    enable2FAButton.layer.cornerRadius = 5
    enable2FAButton.clipsToBounds = true
  }
  
  private func setSpinnerStatus(isSpinning: Bool) {
    if isSpinning {
      spinner.isHidden = false
      spinner.startAnimating()
    } else {
      spinner.isHidden = true
      spinner.stopAnimating()
    }
  }
}

// MARK: Enable2FAViewControllerProtocol

extension Enable2FAViewController: Enable2FAViewControllerProtocol {
  func displayError(message: String) {
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  func setQRCodeData(data: TwoFactorAuthAPI) {
    setSpinnerStatus(isSpinning: false)
    qrCodeImage.kf.setImage(with: data.qrCodeUrl)
    manualCodeLabel.text = data.manualCode
  }
  
  func back() {
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - UIKeyboardNotifications

extension Enable2FAViewController {
  
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
    
    if let field = gaCodeTextField, !frame.contains(field.frame.origin) {
      scrollView.scrollRectToVisible(field.frame, animated: true)
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    scrollView.contentInset = UIEdgeInsets.zero
    scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
  }
}

