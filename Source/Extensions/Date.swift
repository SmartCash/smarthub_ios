//
//  Date.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 24/10/18.
//  Copyright © 2018 Erick Vavretchek. All rights reserved.
//

import Foundation

extension Date {
  
  // Convert UTC (or GMT) to local time
  func toLocalTime() -> Date {
    let timezone = TimeZone.current
    let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
    return Date(timeInterval: seconds, since: self)
  }
  
  // Convert local time to UTC (or GMT)
  func toGlobalTime() -> Date {
    let timezone = TimeZone.current
    let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
    return Date(timeInterval: seconds, since: self)
  }
}
