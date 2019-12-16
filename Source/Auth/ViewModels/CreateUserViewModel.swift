//
//  CreateUserViewModel .swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 10/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit

protocol CreateUserViewControllerProtocol: class, LoadingCapable {
  func displayError(message: String)
  func setRecoveryKey(_ key: String)
}


class CreateUserViewModel {
  
  unowned let viewController: CreateUserViewControllerProtocol
  let authStore: AuthStore
  
  init(viewController: CreateUserViewControllerProtocol,
       authStore: AuthStore = AuthStore()) {
    self.viewController = viewController
    self.authStore = authStore
  }
  
  func viewDidLoad() {
    viewController.showLoadingView(message: "Creating your Master Security Code...")
    authStore.createRecoveryKey { [weak self] result in
      self?.viewController.hideLoadingView()
      switch result {
      case .success(let recoveryKey):
        self?.viewController.setRecoveryKey(recoveryKey)
      case .failure:
        self?.viewController.displayError(message: "Error creating Master Security Code!\nVerify your internet connection and restart the App.")
      }
    }
  }
  
  func createUser(username: String, password: String, recoveryKey: RecoveryKey, firstName: String, lastName: String) {
    
    authStore.keychainClient.wallets = nil
    viewController.showLoadingView(message: "Creating your account...")
    authStore.createUser(username: username, password: password, recoveryKey: recoveryKey, firstName: firstName, lastName: lastName) { [weak self] result in
      self?.viewController.hideLoadingView()
      switch result {
      case .success:
        self?.login(username: username, password: password, twoFACode: "")
      case .failure:
        self?.viewController.displayError(message: "Create User Error")
      }
    }
  }

  func login(username: String, password: String, twoFACode: String) {
    authStore.login(username: username, password: password, twoFACode: twoFACode) { [weak self] result in
      switch result {
      case .success:
        (UIApplication.shared.delegate as? AppDelegate)?.appScreenSwitcher.switchToMainScreen()
      case .failure:
        self?.viewController.displayError(message: "Login Error")
      }
    }
  }
}
