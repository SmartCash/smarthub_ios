//
//  ExportPrivateKeyViewModel.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 17/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation

protocol ExportPrivateKeyViewControllerProtocol: class, LoadingCapable {
  func displayError(message: String)
  func receivePrivateKeys(privateKeys: [PrivateKey])
}

class ExportPrivateKeyViewModel {
  
  unowned let viewController: ExportPrivateKeyViewControllerProtocol
  let authStore: AuthStore
  let smartcashAPIStore: SmartcashAPIStore
  
  init(viewController: ExportPrivateKeyViewControllerProtocol,
       authStore: AuthStore = AuthStore(),
       smartcashAPIStore: SmartcashAPIStore = SmartcashAPIStore()) {
    self.viewController = viewController
    self.authStore = authStore
    self.smartcashAPIStore = smartcashAPIStore
  }
  
  // MARK: Actions Received
  
  func viewDidLoad() {
    
  }
  
  func exportPrivateKeys(recoveryKey: RecoveryKey) {
    viewController.showLoadingView(message: "Exporting your private keys...")
    authStore.exportPrivateKey(recoveryKey: recoveryKey) { [weak self] result in
      self?.viewController.hideLoadingView()
      switch result {
      case .success(let privateKeys):
        self?.viewController.receivePrivateKeys(privateKeys: privateKeys.accounts)
      case .failure:
        self?.viewController.displayError(message: "Error exporting private keys")
      }
    }
  }
}


