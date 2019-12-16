//
//  SmartCashAPIError.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 27/10/18.
//  Copyright © 2018 Erick Vavretchek. All rights reserved.
//

import Foundation

struct SmartCashAPIError: Decodable, Error {
  let data: String?
  let error: ErrorMessage
  let status: String
  let isValid: Bool
}

extension SmartCashAPIError: LocalizedError {
  public var errorDescription: String? {
    return NSLocalizedString(self.error.message, comment: "")
  }
}

struct ErrorMessage: Decodable {
  let message: String
}
