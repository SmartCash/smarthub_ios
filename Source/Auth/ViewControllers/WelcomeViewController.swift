//
//  WelcomeViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 26/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class WelcomeViewController: UIViewController {
  
  
  @IBOutlet weak var createUserButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUIElements()
    prepareNavigationController()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Analytics.setScreenName("Welcome", screenClass: nil)
  }
  
  // MARK: Private
  
  private func prepareUIElements() {
    createUserButton.layer.cornerRadius = 5
    createUserButton.clipsToBounds = true
    
    loginButton.layer.cornerRadius = 5
    loginButton.clipsToBounds = true
  }
  
  private func prepareNavigationController() {
    title = "Welcome"
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .always
    }
  }
  
  // MARK: Actions  
  
  @IBAction func createUserButtonAction(_ sender: Any) {
    
    let storyboard = UIStoryboard(name: "Auth", bundle: nil)
    let createUserViewController = storyboard.instantiateViewController(withIdentifier: String(describing: CreateUserViewController.self))
    createUserViewController.title = "Create User"
    navigationController?.pushViewController(createUserViewController, animated: true)
  }
  
  @IBAction func loginButtonAction(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Auth", bundle: nil)
    let loginViewController = storyboard.instantiateViewController(withIdentifier: String(describing: LoginViewController.self))
    loginViewController.title = "Login"
    navigationController?.pushViewController(loginViewController, animated: true)
  }
}
