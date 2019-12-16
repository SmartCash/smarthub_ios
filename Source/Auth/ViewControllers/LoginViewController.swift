//
//  LoginViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 11/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class LoginViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var TwoFACodeTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  var viewModel: LoginViewModel!
  var loadingView: UIView = LoadingView.make()
  var activeTextField: UITextField?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = LoginViewModel(viewController: self)
    loginButton.layer.cornerRadius = 5
    registerForKeyboardNotifications()
    usernameTextField.becomeFirstResponder()
    
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Analytics.setScreenName("Login", screenClass: nil)
  }
  
  // MARK: Actions
  
  @IBAction func viewTapAction(_ sender: Any) {
    view.endEditing(true)
  }
  
  @IBAction func loginAction(_ sender: Any) {
    guard
      let username = usernameTextField.text,
      let password = passwordTextField.text
      else { return }
    view.endEditing(true)
    viewModel.login(username: username, password: password, twoFACode: TwoFACodeTextField.text ?? "")
  }
  
  
}

// MARK: LoginViewControllerProtocol

extension LoginViewController: LoginViewControllerProtocol {
  func displayError(message: String) {
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
}

// MARK: - UIKeyboardNotifications

extension LoginViewController {
  
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

