//
//  CreateUserViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 10/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import ToastSwiftFramework
import FirebaseAnalytics

class CreateUserViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  @IBOutlet weak var recoveryKeyTextField: UITextField!
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var createUserButton: UIButton!
  @IBOutlet weak var warningView: UIView!
  @IBOutlet weak var recoveryKeyLabel: UILabel!
  
  var viewModel: CreateUserViewModel!
  var loadingView: UIView = LoadingView.make()
  var activeTextField: UITextField?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = CreateUserViewModel(viewController: self)
    viewModel.viewDidLoad()
    prepareUIElements()
    
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
    }
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Analytics.setScreenName("Create User", screenClass: nil)
  }
  
  // MARK: Actions
  
  
  @IBAction func createUserAction(_ sender: Any) {
    guard
      let username = usernameTextField.text,
      let password = passwordTextField.text,
      let confirmPassword = confirmPasswordTextField.text,
      password == confirmPassword,
      let recoveryKey = recoveryKeyTextField.text,
      recoveryKey == recoveryKeyLabel.text
      else {
        displayError(message: "Fill all required fields!")
        return
    }
    view.endEditing(true)
    
    viewModel.createUser(username: username, password: password, recoveryKey: recoveryKey, firstName: firstNameTextField.text ?? "", lastName: lastNameTextField.text ?? "")
  }
  
  @IBAction func copyRecoveryKeyAction(_ sender: Any) {
    UIPasteboard.general.string = recoveryKeyLabel.text!
    print(recoveryKeyLabel.text!)
    view.makeToast("Master Security Code copied to clipboard")
    view.endEditing(true)
  }
  @IBAction func viewTapAction(_ sender: Any) {
    view.endEditing(true)
  }
  
  // MARK: Private
  
  private func prepareUIElements() {
    registerForKeyboardNotifications()
    warningView.layer.borderWidth = 2
    warningView.layer.cornerRadius = 5
    warningView.clipsToBounds = true
    warningView.layer.borderColor = SmartcashKit.Colors.black.cgColor
    createUserButton.layer.cornerRadius = 5
  }
  
  func screenShotMethod() {
    //Create the UIImage
//    UIGraphicsBeginImageContext(view.frame.size)
    UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0.0)
    
    if let context = UIGraphicsGetCurrentContext() {
      view.layer.render(in: context)
      if let image = UIGraphicsGetImageFromCurrentImageContext() {
        UIGraphicsEndImageContext()
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
      }
    }
  }
}

// MARK: CreateUserViewControllerProtocol

extension CreateUserViewController: CreateUserViewControllerProtocol {
  func displayError(message: String) {
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  func setRecoveryKey(_ key: String) {
    recoveryKeyLabel.text = key
    screenShotMethod()
  }
}

// MARK: - UIKeyboardNotifications

extension CreateUserViewController {
  
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
