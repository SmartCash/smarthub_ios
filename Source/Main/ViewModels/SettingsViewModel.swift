//
//  SettingsViewModel.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 14/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation

protocol SettingsViewControllerProtocol: class {
  func displayError(message: String)
  func enable2FA()
  func disable2FA()
  func displayImportPrivateKeyScreen()
  func displayExportPrivateKeyScreen()
  func logOffCompleted()
}

class SettingsViewModel {
  
  unowned let viewController: SettingsViewControllerProtocol
  let authStore: AuthStore
  
  init(viewController: SettingsViewControllerProtocol,
       authStore: AuthStore = AuthStore()) {
    self.viewController = viewController
    self.authStore = authStore
  }
  
  func viewDidLoad() {

  }
  
  // MARK: Actions Received
  
  func twoFactorAuthentication() {
    if authStore.is2FAEnabled() {
      viewController.disable2FA()
    } else {
      viewController.enable2FA()
    }
  }
  
  func importPrivateKey() {
    viewController.displayImportPrivateKeyScreen()
  }
  
  func exportPrivateKey() {
    viewController.displayExportPrivateKeyScreen()
  }
  
  func logOff() {
    authStore.logOff { [weak self] result in
      switch result {
      case .success:
        self?.viewController.logOffCompleted()
      case .failure:
        print("failure")
        self?.viewController.logOffCompleted()
      }
    }
  }

}
