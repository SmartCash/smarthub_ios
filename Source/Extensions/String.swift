//
//  String.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 23/10/18.
//  Copyright © 2018 Erick Vavretchek. All rights reserved.
//

import UIKit

extension String {
  func htmlAttributedString() -> NSMutableAttributedString? {
    guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
    guard let html = try? NSMutableAttributedString(
      data: data,
      options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
      documentAttributes: nil) else { return nil }
    return html
  }
  
  func isDecimal() -> Bool {
    let usLocaleDecimalString = self.replacingOccurrences(of: ",", with: ".")
    let formatter = NumberFormatter()
    formatter.allowsFloats = true
//    formatter.locale = Locale.current
    formatter.locale = Locale(identifier: "en_US")
    return formatter.number(from: usLocaleDecimalString) != nil
  }
  
  func toUSDecimal() -> Decimal? {
    let usLocaleDecimalString = self.replacingOccurrences(of: ",", with: ".")
    let formatter = NumberFormatter()
    formatter.allowsFloats = true
    formatter.locale = Locale(identifier: "en_US")
    if let number = formatter.number(from: usLocaleDecimalString) {
      return number.decimalValue
    } else {
      return nil
    }
  }
}
