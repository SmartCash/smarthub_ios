//
//  TwoFactorAuthAPI.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 12/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TwoFactorAuthAPI {
  let qrCodeUrl: URL
  let manualCode: String
}

extension TwoFactorAuthAPI: ResponseObjectSerializable {
  init?(json: JSON) {
    guard
      let qrCodeUrl = json["data"]["qrCodeImageUrl"].url,
      let manualCode = json["data"]["manualEntrySetupCode"].string
    else { return nil }
    self.qrCodeUrl = qrCodeUrl
    self.manualCode = manualCode
  }
}

