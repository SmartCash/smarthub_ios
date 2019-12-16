//
//  MainViewModel .swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 8/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation

protocol MainViewControllerProtocol: class, LoadingCapable {
  func displayError(message: String)
  func update()
  func logOffCompleted()
}

class MainViewModel {
  
  unowned let viewController: MainViewControllerProtocol
  let smartcashAPIStore: SmartcashAPIStore
  let authStore: AuthStore
  
//  var myWallet: MyWalletsAPI?
  
  init(viewController: MainViewControllerProtocol,
       smartcashAPIStore: SmartcashAPIStore = SmartcashAPIStore(),
       authStore: AuthStore = AuthStore()) {
    self.viewController = viewController
    self.smartcashAPIStore = smartcashAPIStore
    self.authStore = authStore
  }
  
  func viewDidLoad() {
    getWallet()
    viewController.update()
  }
  
  func getWallet() {
    
    viewController.showLoadingView(message: "Loading Wallets...")
    smartcashAPIStore.getWallet { [weak self] result in
      self?.viewController.hideLoadingView()
      switch result {
      case .success:
//        self?.myWallet = wallet
        self?.viewController.update()
      case .failure:
        self?.viewController.displayError(message: "Error retrieving your wallet.\nPlease try again later.")
      }
    }
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
