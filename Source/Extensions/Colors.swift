//
//  Colors .swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 17/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init(hex: String) {
    var characterSet = CharacterSet.whitespacesAndNewlines
    characterSet.formUnion(CharacterSet(charactersIn: "#"))
    let cString = hex.trimmingCharacters(in: characterSet).uppercased()
    
    var rgbValue: UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    switch cString.characters.count {
    case 6:
      self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0))
    case 8:
      self.init(red: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0,
                green: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
                blue: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
                alpha: CGFloat(rgbValue & 0x000000FF) / 255.0)
    default:
      self.init(white: 1.0, alpha: 1.0)
    }
  }
}

struct SmartcashKit {
  struct Colors {
    static let yellow = UIColor(hex: "f5b717") // 245 183 23
    static let yellowBg = UIColor(hex: "f5b717") // 245 183 23
    static let black = UIColor(hex: "303030") // 48 48 48
  }
}
