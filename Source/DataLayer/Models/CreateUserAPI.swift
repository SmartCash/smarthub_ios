//
//  CreateUserAPI .swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 8/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//


import Foundation
import SwiftyJSON

struct CreateUserAPI {
//  let password: String
//  let confirmPassword: String
//  let userDescription: String
//  let isPhoneVerified: Bool
//  let dob: String
  let notifications: Int
  let userId: Int
//  let firstName: String
//  let lastName: String
  let username: String
//  let facebookId: String
  let countryCode: String
  let recoveryKey: RecoveryKey
}

extension CreateUserAPI: ResponseObjectSerializable {
  init?(json: JSON) {
    guard
      let username = json["data"]["username"].string,
      let countryCode = json["data"]["countryCode"].string,
      let userId = json["data"]["userId"].int,
      let notifications = json["data"]["notifications"].int,
      let recoveryKey = json["data"]["recoveryKey"].string
      else {
        return nil
    }
    
    self.username = username
    self.countryCode = countryCode
    self.userId = userId
    self.notifications = notifications
    self.recoveryKey = recoveryKey
  }
}
