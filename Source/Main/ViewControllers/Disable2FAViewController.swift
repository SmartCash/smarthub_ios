//
//  Disable2FAViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 15/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class Disable2FAViewController: UIViewController {
  
  @IBOutlet weak var recoveryKeyTextField: UITextField!
  @IBOutlet weak var disableButton: UIButton!
  
  var viewModel: Disable2FAViewModel!
  var loadingView: UIView = LoadingView.make()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    prepareUIElements()
    
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Analytics.setScreenName("Disable 2FA", screenClass: nil)
  }
  
  // MARK: Actions
  
  @IBAction func disableAction() {
    guard let recoveryKey = recoveryKeyTextField.text else {
      displayError(message: "Enter your Master Security Code")
      return
    }
    view.endEditing(true)
    viewModel.disable(recoveryKey: recoveryKey)
  }
  
  // MARK: Private
  
  private func prepareUIElements() {
    
    title = "Disable 2FA"
    
    disableButton.layer.cornerRadius = 5
    disableButton.clipsToBounds = true
  }
}

extension Disable2FAViewController: Disable2FAViewControllerProtocol {
  func displayError(message: String) {
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  func back() {
    navigationController?.popViewController(animated: true)
  }
}
