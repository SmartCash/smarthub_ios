//
//  AddressBookViewModel.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 8/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation

protocol AddressBookViewControllerProtocol: class, LoadingCapable {
  func displayError(message: String)
  func update()
  func dismissScreen()
}

protocol AddressBookProtocol: class {
  func didReceive(address: String)
}

class AddressBookViewModel {
  
  unowned let viewController: AddressBookViewControllerProtocol
  let smartcashAPIStore: SmartcashAPIStore
  let authStore: AuthStore
  let delegate: AddressBookProtocol?
  
  var addresses = [Address]()
  
//  var myWallet: MyWalletsAPI?
  
  init(viewController: AddressBookViewControllerProtocol,
       smartcashAPIStore: SmartcashAPIStore = SmartcashAPIStore(),
       authStore: AuthStore = AuthStore(),
       delegate: AddressBookProtocol? = nil) {
    self.viewController = viewController
    self.smartcashAPIStore = smartcashAPIStore
    self.authStore = authStore
    self.delegate = delegate
  }
  
  func viewDidLoad() {
    getAddressBook(force: true)
  }
  
  func deleteAddress(id: Int) {
    smartcashAPIStore.deleteAddressinAddressBook(id: id) { [weak self] result in
      switch result {
      case .success:
        self?.getAddressBook(force: true)
      case .failure:
        self?.getAddressBook()
        self?.viewController.displayError(message: "Error removing address")
      }
    }
  }
  
  func getAddressBook(force: Bool = false) {
    
    if !force {
      if let addresses = MyDetails.shared.addressBook {
        self.addresses = addresses
        viewController.update()
      } else {
        smartcashAPIStore.getAddressBook { [weak self] result in
          self?.viewController.hideLoadingView()
          switch result {
          case .success(let addressBook):
            self?.addresses = addressBook.addresses
            MyDetails.shared.addressBook = addressBook.addresses
            self?.viewController.update()
          case .failure:
            self?.viewController.displayError(message: "Error getting Address Book")
          }
        }
      }
    } else {
      
      viewController.showLoadingView(message: "Loading address book...")
      smartcashAPIStore.getAddressBook { [weak self] result in
        self?.viewController.hideLoadingView()
        switch result {
        case .success(let addressBook):
          self?.addresses = addressBook.addresses
          self?.viewController.update()
          MyDetails.shared.addressBook = addressBook.addresses
        case .failure:
          self?.viewController.displayError(message: "Error getting Address Book")
        }
      }
    }
  }
  
  func didSelectAddress(index: Int) {
    delegate?.didReceive(address: addresses[index].address)
    viewController.dismissScreen()
  }
}
