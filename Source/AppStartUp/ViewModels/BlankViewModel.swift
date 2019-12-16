//
//  BlankViewModel.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 11/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation

protocol BlankViewControllerProtocol: class, LoadingCapable {
  
  
}

class BlankViewModel {
  unowned let viewController: BlankViewControllerProtocol
  
  
  init(viewController: BlankViewControllerProtocol) {
    self.viewController = viewController
  }

}
