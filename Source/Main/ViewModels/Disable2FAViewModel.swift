//
//  Disable2FAViewModel.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 15/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
protocol Disable2FAViewControllerProtocol: class, LoadingCapable {
  func displayError(message: String)
  func back()
}

class Disable2FAViewModel {
  
  unowned let viewController: Disable2FAViewControllerProtocol
  let authStore: AuthStore
  var delegate: TwoFAUpdateDelegate?
  
  init(viewController: Disable2FAViewControllerProtocol,
       authStore: AuthStore = AuthStore(),
       delegate: TwoFAUpdateDelegate? = nil) {
    self.viewController = viewController
    self.authStore = authStore
    self.delegate = delegate
  }
  
  // MARK: Actions Received
  
  func viewDidLoad() {

  }
  
  func disable(recoveryKey: RecoveryKey) {
    viewController.showLoadingView(message: "Disabling 2FA...")
    authStore.disable2FA(recoveryKey: recoveryKey) { [weak self] result in
      self?.viewController.hideLoadingView()
      switch result {
      case .success:
        print("s")
        self?.authStore.save2FAStatus(enabled: false)
        self?.viewController.back()
        self?.delegate?.update2FAStatus(isEnabled: false)
      case .failure:
        self?.viewController.displayError(message: "Error, please confirm your Master Security Code")
      }
    }
  }
}

