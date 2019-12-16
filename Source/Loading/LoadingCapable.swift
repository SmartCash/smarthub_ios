//
//  LoadingCapable .swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 10/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import UIKit

protocol LoadingCapable: class {
  
  var loadingView: UIView { get set }
  
  var loadingShouldBlockInteractions: Bool { get }
  
  func showLoadingView()
  func showLoadingView(message: String?)
  func showLoadingView(message: String?, animated: Bool)
  func showLoadingView(message: String?, animated: Bool, delay: Double)
  
  func hideLoadingView()
  func hideLoadingView(animated: Bool)
  
  func loadingViewAnimationDuration() -> Double
}

extension LoadingCapable where Self: UIViewController {
  
  var loadingShouldBlockInteractions: Bool {
    return false
  }
  
  func showLoadingView() {
    showLoadingView(message: nil, animated: true)
  }
  
  func showLoadingView(message: String?) {
    showLoadingView(message: message, animated: true)
  }
  
  func showLoadingView(message: String?, animated: Bool) {
    showLoadingView(message: message, animated: animated, delay: 0)
  }
  
  func showLoadingView(message: String?, animated: Bool, delay: Double) {
    loadingView.alpha = 0
    
    view.addSubview(loadingView)
    view.bringSubviewToFront(loadingView)
    
    loadingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    loadingView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    
    if let defaultLoadingView = loadingView as? LoadingView {
      defaultLoadingView.loadingMessageLabel.text = message
      defaultLoadingView.startAnimating()
    }
    
    let duration = animated ? loadingViewAnimationDuration() : 0
    
    if loadingShouldBlockInteractions {
      UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    UIView.animate(withDuration: duration, delay: delay, options: [], animations: { [weak self] in
      self?.loadingView.alpha = 1.0
      }, completion: nil)
  }
  
  func hideLoadingView() {
    hideLoadingView(animated: true)
  }
  
  func hideLoadingView(animated: Bool) {
    let duration = animated ? loadingViewAnimationDuration() : 0.0
    
    UIView.animate(withDuration: duration, animations: { [weak self] in
      self?.loadingView.alpha = 0.0
      }, completion: { [weak self] (_) in
        self?.loadingView.removeFromSuperview()
    })
    
    UIApplication.shared.endIgnoringInteractionEvents()
  }
  
  func loadingViewAnimationDuration() -> Double {
    return 0.3
  }
}
