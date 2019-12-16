//
//  LoginViewModel .swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 11/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit

protocol LoginViewControllerProtocol: class, LoadingCapable {
  func displayError(message: String)
}


class LoginViewModel {
  
  unowned let viewController: LoginViewControllerProtocol
  let authStore: AuthStore
  let smartcashAPIStore: SmartcashAPIStore
  
  init(viewController: LoginViewControllerProtocol,
       authStore: AuthStore = AuthStore(),
       smartcashAPIStore: SmartcashAPIStore = SmartcashAPIStore()) {
    self.viewController = viewController
    self.authStore = authStore
    self.smartcashAPIStore = smartcashAPIStore
  }
  
  func login(username: String, password: String, twoFACode: String) {
    viewController.showLoadingView(message: "Logging you in...")
    
    authStore.login(username: username, password: password, twoFACode: twoFACode) { [weak self] result in
      self?.viewController.hideLoadingView()
      switch result {
      case .success:
//        self?.viewController.showLoadingView(message: "Loading your wallets...")
        (UIApplication.shared.delegate as? AppDelegate)?.appScreenSwitcher.switchToBlankScreen(message: "Loading your wallets...")
        self?.smartcashAPIStore.getWallet(completionHandler: { result in
          switch result {
          case .success:
            (UIApplication.shared.delegate as? AppDelegate)?.appScreenSwitcher.switchToMainScreen()
          case .failure:
            self?.viewController.displayError(message: "Error retrieving your wallet")
          }
        })
        
      case .failure:
        self?.viewController.displayError(message: "Login Error")
      }
    }
  }
}
