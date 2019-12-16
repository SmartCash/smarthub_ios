//
//  Enable2FAViewModel.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 14/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation

protocol Enable2FAViewControllerProtocol: class, LoadingCapable {
  func displayError(message: String)
  func setQRCodeData(data: TwoFactorAuthAPI)
  func back()
}

protocol TwoFAUpdateDelegate: class {
  func update2FAStatus(isEnabled: Bool)
}

class Enable2FAViewModel {
  
  unowned let viewController: Enable2FAViewControllerProtocol
  let authStore: AuthStore
  var delegate: TwoFAUpdateDelegate?
  var manualCode: String?
  
  init(viewController: Enable2FAViewControllerProtocol,
       authStore: AuthStore = AuthStore(),
       delegate: TwoFAUpdateDelegate? = nil) {
    self.viewController = viewController
    self.authStore = authStore
    self.delegate = delegate
  }
  
  // MARK: Actions Received
  
  func viewDidLoad() {
    get2FACodes()
  }
  
  func enable(gaCode: String) {
    viewController.showLoadingView(message: "Enabling 2FA...")
    authStore.enable2FA(gaCode: gaCode) { [weak self] result in
      self?.viewController.hideLoadingView()
      switch result {
      case .success:
        print("s")
        self?.authStore.save2FAStatus(enabled: true)
        self?.viewController.back()
        self?.delegate?.update2FAStatus(isEnabled: true)
      case .failure:
        self?.viewController.displayError(message: "Error, please confirm your\nGoogle Authenticator code")
      }
    }
  }
  
  // MARK: Private
  
  private func get2FACodes() {
    authStore.get2FA { [weak self] result in
      switch result {
      case .success(let twoFactorAuthAPI):
        self?.manualCode = twoFactorAuthAPI.manualCode
        self?.viewController.setQRCodeData(data: twoFactorAuthAPI)
      case .failure:
        self?.viewController.displayError(message: "Error getting 2FA data, try again.")
        self?.viewController.back()
      }
    }
  }
  
  
  
}
