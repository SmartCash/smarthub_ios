//
//  ImportPrivateKeyViewModel.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 16/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation

protocol ImportPrivateKeyViewControllerProtocol: class, LoadingCapable {
  func displayError(message: String)
  func navigateToMain()
}

class ImportPrivateKeyViewModel {
  
  unowned let viewController: ImportPrivateKeyViewControllerProtocol
  let authStore: AuthStore
  let smartcashAPIStore: SmartcashAPIStore
  
  init(viewController: ImportPrivateKeyViewControllerProtocol,
       authStore: AuthStore = AuthStore(),
       smartcashAPIStore: SmartcashAPIStore = SmartcashAPIStore()) {
    self.viewController = viewController
    self.authStore = authStore
    self.smartcashAPIStore = smartcashAPIStore
  }
  
  // MARK: Actions Received
  
  func viewDidLoad() {
    
  }
  
  func importPrivateKey(privateKey: String, recoveryKey: RecoveryKey, password: String, label: String) {
    viewController.showLoadingView(message: "Importing your account...")
    authStore.importPrivateKey(privateKey: privateKey, recoveryKey: recoveryKey, password: password, label: label) { [weak self] result in
      switch result {
      case .success:
        self?.smartcashAPIStore.getWallet(force: true, completionHandler: { [weak self] result in
          self?.viewController.hideLoadingView()
          switch result {
          case .success:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PRIVATE_KEY_IMPORTED"), object: nil, userInfo: ["accountName": label])
            self?.viewController.navigateToMain()
          case .failure:
            self?.viewController.displayError(message: "Import successful!\nRefresh your wallets")
          }
        })
      case .failure:
        self?.viewController.hideLoadingView()
        self?.viewController.displayError(message: "Error importing Private Key")
      }
    }
  }
}


