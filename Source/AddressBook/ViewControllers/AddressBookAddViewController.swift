//
//  AddressBookAddViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 8/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class AddressBookAddViewController: UIViewController {
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var addressTextField: UITextField!
  @IBOutlet weak var qrButton: UIButton!
  
  var viewModel: AddressBookAddViewModel!
  var loadingView: UIView = LoadingView.make()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    prepareNavigationController()
    
    qrButton.layer.cornerRadius = 5
    qrButton.layer.borderColor = SmartcashKit.Colors.yellow.cgColor
    qrButton.layer.borderWidth = 1
    qrButton.clipsToBounds = true
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Analytics.setScreenName("Add Address Book", screenClass: nil)
  }
  
  // MARK: Actions
  
  @IBAction func cancelAction(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func qrButtonAction(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let qRScannerController = storyboard.instantiateViewController(withIdentifier: "QRScannerController") as? QRScannerController {
      qRScannerController.delegate = self
      present(qRScannerController, animated: true, completion: nil)
    }
  }
  
  @IBAction func saveAction(_ sender: Any) {
    guard
      let name = nameTextField.text,
      let address = addressTextField.text,
      name != "",
      address != ""
      else { return }
    view.endEditing(true)
    viewModel.save(name: name, address: address)
  }
  
  // MARK: Private
  
  private func prepareNavigationController() {
    title = "Add Address"
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
    }
  }
}

extension AddressBookAddViewController: QRCodeDelegate {
  func updateQRCode(withAddress address: String) {
        
    var workAddress = address
    
    guard let index = address.index(of: ":") else {
      addressTextField.text = address
      return
    }
    let indexStartOfText = address.index(address.startIndex, offsetBy: 0)
    let indexEndOfText = address.index(address.startIndex, offsetBy: index.encodedOffset + 1)
    let scheme = address[indexStartOfText..<indexEndOfText]
    if scheme == "smartcash:" {
      workAddress = address.replacingOccurrences(of: scheme, with: "smartcash://")
      print(workAddress)
    }
    
    
    if let index2 = workAddress.index(of: "?") {
      print(index2.encodedOffset)
      workAddress.insert("/", at: index2)
      print(workAddress)
    }
    

    
    if let uri = URL(string: workAddress), let address = uri.host {
      addressTextField.text = address
    } else {
      addressTextField.text = address
    }
  }
}

extension AddressBookAddViewController: AddressBookAddViewControllerProtocol {
  func displayError(message: String) {
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  func dismissScreen() {
    dismiss(animated: true, completion: nil)
  }
}
