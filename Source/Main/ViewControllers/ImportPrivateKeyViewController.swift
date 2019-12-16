//
//  ImportPrivateKeyViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 16/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class ImportPrivateKeyViewController: UIViewController {
  
  @IBOutlet weak var privateKeyTextField: UITextField!
  @IBOutlet weak var securityIdTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var labelTextField: UITextField!
  @IBOutlet weak var importButton: UIButton!
  
  var viewModel: ImportPrivateKeyViewModel!
  var loadingView: UIView = LoadingView.make()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUIElements()
    prepareNavigationController()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Analytics.setScreenName("Import Private Key", screenClass: nil)
  }
  
  // MARK: Actions
  
  @IBAction func importPrivateKeyAction() {
   guard
    let privateKey = privateKeyTextField.text,
    let securityId = securityIdTextField.text,
    let password = passwordTextField.text
    else {
      displayError(message: "Enter all fields")
      return
    }
    view.endEditing(true)
    viewModel.importPrivateKey(privateKey: privateKey, recoveryKey: securityId, password: password, label: labelTextField.text ?? "")
  }
  
  // MARK: Private
  
  private func prepareUIElements() {
    importButton.layer.cornerRadius = 5
    importButton.clipsToBounds = true
  }
  
  private func prepareNavigationController() {
    title = "Import Private Key"
//    navigationController?.navigationBar.isTranslucent = false
//    navigationController?.navigationBar.barTintColor = Color.smartYellow
//    navigationController?.navigationBar.tintColor = Color.smartBlack
//    navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Color.smartBlack]

    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
    }
  }
}

extension ImportPrivateKeyViewController: ImportPrivateKeyViewControllerProtocol {
  func displayError(message: String) {
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  func navigateToMain() {
    tabBarController?.selectedIndex = 1
  }
}
