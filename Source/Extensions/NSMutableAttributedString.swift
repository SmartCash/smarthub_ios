//
//  NSMutableAttributedString.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 23/10/18.
//  Copyright © 2018 Erick Vavretchek. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
  func setFontFace(font: UIFont, color: UIColor? = nil) -> NSMutableAttributedString {
    beginEditing()
    self.enumerateAttribute(.font, in: NSRange(location: 0, length: self.length)) { (value, range, stop) in
      if let f = value as? UIFont, let newFontDescriptor = f.fontDescriptor.withFamily(font.familyName).withSymbolicTraits(f.fontDescriptor.symbolicTraits) {
        let newFont = UIFont(descriptor: newFontDescriptor, size: font.pointSize)
        removeAttribute(.font, range: range)
        addAttribute(.font, value: newFont, range: range)
        if let color = color {
          removeAttribute(.foregroundColor, range: range)
          addAttribute(.foregroundColor, value: color, range: range)
        }
      }
    }
    endEditing()
    return self
  }
}
