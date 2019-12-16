//
//  ExportPrivateKeyViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 17/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class ExportPrivateKeyViewController: UIViewController {
  
  @IBOutlet weak var securityIdTextField: UITextField!
  @IBOutlet weak var exportButton: UIButton!
  
  var viewModel: ExportPrivateKeyViewModel!
  var loadingView: UIView = LoadingView.make()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUIElements()
    prepareNavigationController()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Analytics.setScreenName("Export Private Key", screenClass: nil)
  }
  
  // MARK: Actions
  
  @IBAction func exportButtonAction() {
    guard !(securityIdTextField.text?.isEmpty)! else {
      displayError(message: "Enter Master Security Code")
      return
    }
    view.endEditing(true)
    viewModel.exportPrivateKeys(recoveryKey: securityIdTextField.text!)
  }
  
  // MARK: Private
  
  private func prepareUIElements() {
    exportButton.layer.cornerRadius = 5
    exportButton.clipsToBounds = true
  }
  
  private func prepareNavigationController() {
    title = "Export Private Keys"
//    navigationController?.navigationBar.isTranslucent = false
//    navigationController?.navigationBar.barTintColor = Color.smartYellow
//    navigationController?.navigationBar.tintColor = Color.smartBlack
//    navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Color.smartBlack]

    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
    }
  }
}

extension ExportPrivateKeyViewController: ExportPrivateKeyViewControllerProtocol {
  func displayError(message: String) {
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  func receivePrivateKeys(privateKeys: [PrivateKey]) {
    var privateKeysText: String = ""
    var error = false
    for privateKey in privateKeys {
      if let wallets = MyDetails.shared.allWallets {
        let wallet = wallets.filter{ $0.address == privateKey.address }
        if wallet.count > 0 {
          privateKeysText += "\(wallet.first!.displayName)\n"
        }
      }
      privateKeysText += """
      Address:\t\(privateKey.address)\n
      Private Key:\t\(privateKey.privateKey)\n
      ==========\n\n
      """
      
      if privateKey.privateKey == "Unable to export Private Key" {
        error = true
      }
    }
    
    if error {
      displayError(message: "Error obtaining Private Keys, make sure you entered a valid Master Security Code")
      return
    }
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let identifier = String(describing: PrivateKeyListViewController.self)
    if let privateKeyListViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? PrivateKeyListViewController {
      privateKeyListViewController.privateKeysText = privateKeysText
      navigationController?.pushViewController(privateKeyListViewController, animated: true)
    }
  }
}
