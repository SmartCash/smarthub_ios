//
//  AddressBookAddViewModel.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 8/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation

protocol AddressBookAddViewControllerProtocol: class, LoadingCapable {
  func displayError(message: String)
  func dismissScreen()
}

protocol AddressBookAddProtocol: class {
  func didSave(address: String)
}

class AddressBookAddViewModel {
  
  unowned let viewController: AddressBookAddViewControllerProtocol
  let smartcashAPIStore: SmartcashAPIStore
  let authStore: AuthStore
  let delegate: AddressBookAddProtocol?
  
  init(viewController: AddressBookAddViewControllerProtocol,
       smartcashAPIStore: SmartcashAPIStore = SmartcashAPIStore(),
       authStore: AuthStore = AuthStore(),
       delegate: AddressBookAddProtocol? = nil) {
    self.viewController = viewController
    self.smartcashAPIStore = smartcashAPIStore
    self.authStore = authStore
    self.delegate = delegate
  }
  
  func save(name: String, address: String) {
    smartcashAPIStore.createAddressinAddressBook(name: name, address: address) { [weak self] result in
      switch result {
      case .success:
        self?.viewController.dismissScreen()
        self?.delegate?.didSave(address: address)
      case .failure:
        self?.viewController.displayError(message: "Error saving address")
      }
    }
  }
  
  
}
