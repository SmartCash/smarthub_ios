//
//  AuthStore .swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 10/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import Alamofire
import LocalAuthentication

class AuthStore {
  
  private let createUserAPIClient: CreateUserAPIClient
  private let loginAPIClient: LoginAPIClient
  private let refreshTokenAPIClient: RefreshTokenAPIClient
  private let logOffAPIClient: LogOffAPIClient
  private let twoFactorAuthAPIClient: TwoFactorAuthAPIClient
  private let privateKeyAPIClient: PrivateKeyAPIClient
  let keychainClient: KeychainClient
  
  init(createUserAPIClient: CreateUserAPIClient = CreateUserAPIClient(),
       loginAPIClient: LoginAPIClient = LoginAPIClient(),
       refreshTokenAPIClient: RefreshTokenAPIClient = RefreshTokenAPIClient(),
       keychainClient: KeychainClient = KeychainClient(),
       logOffAPIClient: LogOffAPIClient = LogOffAPIClient(),
       twoFactorAuthAPIClient: TwoFactorAuthAPIClient = TwoFactorAuthAPIClient(),
       privateKeyAPIClient: PrivateKeyAPIClient = PrivateKeyAPIClient()) {
    self.createUserAPIClient = createUserAPIClient
    self.loginAPIClient = loginAPIClient
    self.refreshTokenAPIClient = refreshTokenAPIClient
    self.keychainClient = keychainClient
    self.logOffAPIClient = logOffAPIClient
    self.twoFactorAuthAPIClient = twoFactorAuthAPIClient
    self.privateKeyAPIClient = privateKeyAPIClient
  }
  
  var isAccessTokenAvailable: Bool {
    return keychainClient.accessToken != nil
  }
  
  var isAccessTokenValid: Bool {
    guard
      isAccessTokenAvailable,
      let expirationString = keychainClient.accessTokenExpiration,
      let expirationTimestamp = Double(expirationString)
    else { return false }
    
    let expirationDate = Date(timeIntervalSince1970: expirationTimestamp)
    return Date() < expirationDate
  }
  
  var isUsernameAndPasswordAvailable: Bool {
    return keychainClient.username != nil && keychainClient.userPassword != nil
  }
  
  var accessToken: String? {
    return keychainClient.accessToken
  }
  
  var refreshToken: String? {
    return keychainClient.refreshToken
  }
  
  func createRecoveryKey(completionHandler: @escaping (Result<RecoveryKey>) -> Void) {
    createUserAPIClient.getRecoveryKey { [weak self] response in
      switch response.result {
      case .success:
        self?.keychainClient.recoveryKey = response.value
      default: break
      }
      completionHandler(response.result)
    }
  }
  
  func createUser(username: String, password: String, recoveryKey: RecoveryKey, firstName: String, lastName: String, completionHandler: @escaping (Result<CreateUserAPI>) -> Void) {
    if let recoveryKey = keychainClient.recoveryKey {
      createUserAPIClient.createUser(username: username, password: password, recoveryKey: recoveryKey, firstName: firstName, lastName: lastName) { [weak self] response in
        switch response.result {
        case .success:
          self?.keychainClient.username = username
          self?.keychainClient.userPassword = password
        default: break
        }
        completionHandler(response.result)
      }
    }
  }
  
  func login(username: String, password: String, twoFACode: String, completionHandler: @escaping (Result<LoginAPI>) -> Void) {
    if isAccessTokenValid {
      (UIApplication.shared.delegate as? AppDelegate)?.appScreenSwitcher.switchToMainScreen()
      let loginAPI = LoginAPI(accessToken: keychainClient.accessToken!, refreshToken: keychainClient.refreshToken!, accessTokenExpiration: keychainClient.accessTokenExpiration!)
      completionHandler(Result.success(loginAPI))
      return
    }
    loginAPIClient.login(username: username, password: password, twoFACode: twoFACode) { [weak self] (response) in
      switch response.result {
      case .success(let loginResult):
        self?.keychainClient.accessToken = loginResult.accessToken
        self?.keychainClient.refreshToken = loginResult.refreshToken
        self?.keychainClient.username = username
        self?.keychainClient.userPassword = password
        self?.keychainClient.accessTokenExpiration = loginResult.accessTokenExpiration
      default: break
      }
      completionHandler(response.result)
    }
  }
  
  func refreshToken(completionHandler: @escaping (Result<LoginAPI>) -> Void) {
    refreshTokenAPIClient.refresh(refreshToken: "") { (reponse) in
      completionHandler(reponse.result)
    }
  }
  
  func logOff(completionHandler: @escaping (Result<Any>) -> Void) {
    if let accessToken = accessToken {
      logOffAPIClient.logOff(accessToken: accessToken, completionHandler: {response in
        completionHandler(response.result)
      })
    }
    clearCredentials()
  }
  
  func get2FA(completionHandler: @escaping (Result<TwoFactorAuthAPI>) -> Void) {
    if let accessToken = accessToken {
      twoFactorAuthAPIClient.get2FA(accessToken: accessToken, completionHandler: { response in
        completionHandler(response.result)
      })
    }
  }
  
  func enable2FA(gaCode: String, completionHandler: @escaping (Result<Any>) -> Void) {
    if let accessToken = accessToken {
      twoFactorAuthAPIClient.enable(gaCode: gaCode, accessToken: accessToken, completionHandler: { response in
        completionHandler(response.result)
      })
    }
  }
  
  func disable2FA(recoveryKey: RecoveryKey, completionHandler: @escaping (Result<Any>) -> Void) {
    if let accessToken = accessToken {
      twoFactorAuthAPIClient.disable(recoveryKey: recoveryKey, accessToken: accessToken, completionHandler: { response in
        completionHandler(response.result)
      })
    }
  }
  
  func save2FAStatus(enabled: Bool) {
    UserDefaults.standard.set(enabled, forKey: "is2FAEnabled")
  }
  
  func is2FAEnabled() -> Bool {
    return UserDefaults.standard.bool(forKey: "is2FAEnabled")
  }
  
  func importPrivateKey(privateKey: String, recoveryKey: RecoveryKey, password: String, label: String, completionHandler: @escaping (Result<Any>) -> Void) {
    if let accessToken = accessToken {
      privateKeyAPIClient.importPrivateKey(accessToken: accessToken, privateKey: privateKey, recoveryKey: recoveryKey, password: password, label: label, completionHandler: { response in
        completionHandler(response.result)
      })
    }
  }
  
  func exportPrivateKey(recoveryKey: RecoveryKey, completionHandler: @escaping (Result<ExportPrivateKeyAPI>) -> Void) {
    if let accessToken = accessToken {
      privateKeyAPIClient.exportPrivateKey(accessToken: accessToken, recoveryKey: recoveryKey, completionHandler: { response in
        completionHandler(response.result)
      })
    }
  }
  
  func requestDeviceAuthentication(completion: @escaping (Bool, Error?) -> Void) {
    LAContext().evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "SmartCash Login", reply: completion)
  }
  
  
  
  
  
  func clearCredentials() {
    keychainClient.accessToken = nil
    keychainClient.refreshToken = nil
    keychainClient.username = nil
    keychainClient.userPassword = nil
    keychainClient.accessTokenExpiration = nil
    keychainClient.wallets = nil
  }
}

