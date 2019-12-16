//
//  SendViewModel.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 26/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import FirebaseAnalytics

protocol SendViewControllerProtocol: class, LoadingCapable {
  func displayError(message: String)
  func paymentSent(from: String)
}

class SendViewModel {
  
  unowned let viewController: SendViewControllerProtocol
  let smartcashAPIStore: SmartcashAPIStore
  
  init(viewController: SendViewControllerProtocol,
       smartcashAPIStore: SmartcashAPIStore = SmartcashAPIStore()) {
    self.viewController = viewController
    self.smartcashAPIStore = smartcashAPIStore
  }
  
  func sendPayment(from: String, to: String, amount: Decimal, userKey: String) {
    viewController.showLoadingView(message: "Sending payment...")
    smartcashAPIStore.sendPayment(from: from, to: to, amount: amount, userKey: userKey) { [weak self] result in
      switch result {
      case .success:
        Analytics.logEvent("SmartCash_Sent", parameters: ["From":from, "To":to, "Amount": amount])
        self?.viewController.showLoadingView(message: "Payment successfully sent!!!")
        self?.smartcashAPIStore.getWallet(completionHandler: { [weak self] result in
          self?.viewController.hideLoadingView()
          switch result {
          case .success:
            self?.viewController.paymentSent(from: from)
          case .failure:
            self?.viewController.displayError(message: "Error refreshing your wallet,\nBut payment was sent successfully.")
          }
        })
      case .failure(let error):
        print(error)
        self?.viewController.hideLoadingView()
        self?.viewController.displayError(message: error.localizedDescription)
      }
    }
  }
}
