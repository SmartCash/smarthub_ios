//
//  NSNotification.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 17/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation

import UIKit

extension NSNotification {
  
  func keyboardHeight() -> CGFloat? {
    guard let frame = keyboardFrame() else { return nil }
    return frame.height
  }
  
  func keyboardFrame() -> CGRect? {
    guard let frame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
      return nil
    }
    
    return frame.cgRectValue
  }
  
  func keyboardAnimationDuration() -> TimeInterval? {
    guard let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {
      return nil
    }
    
    return duration.doubleValue
  }
}
