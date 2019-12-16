//
//  LoginAPI .swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 10/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import SwiftyJSON

struct LoginAPI {
  let accessToken: AccessToken
  let refreshToken: RefreshToken
  let accessTokenExpiration: String
}

extension LoginAPI: ResponseObjectSerializable {
  init?(json: JSON) {
    guard
      let accessToken = json["access_token"].string,
      let refreshToken = json["refresh_token"].string,
      let accessTokenExpiration = json["expires_in"].double
    else { return nil }
    self.accessToken = accessToken
    self.refreshToken = refreshToken
    self.accessTokenExpiration = "\(Date(timeIntervalSinceNow: accessTokenExpiration).timeIntervalSince1970)"
  }
}
