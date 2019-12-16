//
//  KeychainTests .swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 10/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import Nimble
import Quick
import OHHTTPStubs
import Alamofire
import KeychainAccess

@testable import SmartcashWallet

class KeychainTests: QuickSpec {
  
  var keychainStub: Keychain!
  var keychainClient: KeychainClient!
  
  
  override func spec() {
    
    beforeEach {
      self.keychainStub = Keychain(service: "KeychainTest")
      self.keychainClient = KeychainClient(keychain: self.keychainStub)
      self.keychainClient.userId = nil
      self.keychainClient.username = nil
      self.keychainClient.userPassword = nil
      self.keychainClient.accessToken = nil
      self.keychainClient.refreshToken = nil
    }
    
    describe("Keychain Client") {
      
      context("User creates an new User Account successfully") {
        
        it("Should store the username on the Keychain") {
          let username = "NewlyCreatedUser"
          self.keychainClient.username = username
          expect(self.keychainClient.username) == username
        }
        
        it("Should store the user password on the Keychain") {
          let password = "NewlyCreatedPassword"
          self.keychainClient.userPassword = password
          expect(self.keychainClient.userPassword) == password
        }
        
        it("Should store the user User ID on the Keychain") {
          let userId = "newUserId"
          self.keychainClient.userId = userId
          expect(self.keychainClient.userId) == userId
        }
      }
    }
  }
}

