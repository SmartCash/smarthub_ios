//
//  LoadingView .swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 10/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit

class LoadingView: UIView {
  
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var loadingMessageLabel: UILabel!
  
  static func make() -> LoadingView {
    let nibName = String(describing: LoadingView.self)
    let view = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! LoadingView
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }
  
  func startAnimating() {
    spinner.startAnimating()
  }
}
