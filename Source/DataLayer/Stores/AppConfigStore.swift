//
//  AppConfigStore .swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 8/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation

class AppConfigStore {
  
  static let shared = AppConfigStore()
    
  private var environment: Environment {
    #if DEBUG
      return .dev
    #else
      return .prod
    #endif
  }
  
  var smartcashBaseURL: URL {
    return environment.smartcashBaseURL
  }
  
  var votingBaseURL: URL {
    return environment.votingBaseURL
  }
  
  var smartcashAPIClientId: String {
    return environment.smartcashAPIClientId
  }
  
  var smartcashAPIClientSecret: String {
    return environment.smartcashAPIClientSecret
  }
  
  var smartcashLoginGrantType: String {
    return environment.smartcashLoginGrantType
  }
  
  private init() {}
  
//  func registerDebugSettingsDefaultValues() {
//    #if DEBUG
//      let defaults = UserDefaults.standard
//      
//      if defaults.string(forKey: DebugSettingsIdentifier.environment) == nil {
//        defaults.setValue(Environment.dev.rawValue, forKey: DebugSettingsIdentifier.environment)
//      }
//      
//      defaults.synchronize()
//    #endif
//  }
//  
//  func updateDebugSettings() {
//    #if DEBUG
//      updateEnvironment()
//    #endif
//  }
  
  // MARK: Private
  
//  private func updateEnvironment() {
//    guard
//      let environmentString = UserDefaults.standard.string(forKey: DebugSettingsIdentifier.environment),
//      let environment = Environment(rawValue: environmentString)
//      else { return }
//    
//    self.environment = environment
//  }
}

//// Identifiers on DebugSettings.bundle/Root.plist
//struct DebugSettingsIdentifier {
//  static let environment = "settings.debug.environments"
//}
