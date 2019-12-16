//
//  BlankViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 11/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit

class BlankViewController: UIViewController {
  
  var viewModel: BlankViewModel!
  var loadingView: UIView = LoadingView.make()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = BlankViewModel(viewController: self)
    
  }
}

extension BlankViewController: BlankViewControllerProtocol {
  
}
