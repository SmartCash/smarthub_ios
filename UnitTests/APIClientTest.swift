//
//  Test.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 8/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import Nimble
import Quick
import OHHTTPStubs
import Alamofire

@testable import SmartcashWallet

class APIClientTest: QuickSpec {
  
  override func spec() {
    
    beforeEach {
      stub(condition: pathEndsWith(CreateUserRouter.create(username: "stub", password: "stub", recoveryKey: "stub", firstName: "stub", lastName: "stub", email: "stub").path)) { _ in
        return OHHTTPStubsResponse(
          fileAtPath: OHPathForFile("CreateUser.json", type(of: self))!,
          statusCode: 200,
          headers: ["Content-Type":"application/json"]
        )
      }
      
      stub(condition: pathEndsWith(CreateUserRouter.getRecoveryKey.path)) { _ in
        return OHHTTPStubsResponse(
          fileAtPath: OHPathForFile("RecoveryKey.json", type(of: self))!,
          statusCode: 200,
          headers: ["Content-Type":"application/json"]
        )
      }
    }
    
    afterEach {
      OHHTTPStubs.removeAllStubs()
    }
    
    describe("API Client") {
      
      context("When user tries to create an user") {
        
        it("Should succesfully obtain a Master Security Code") {
          waitUntil { done in
            let createUserAPIClient = CreateUserAPIClient()
            createUserAPIClient.getRecoveryKey(completionHandler: { (response) in
              expect(response.error).to(beNil())
              
              let recoveryKey = response.value!
              expect(recoveryKey) == "mGPQhM-Xd6G8d-jXofxM-qY6RPd-cpWbaR-ggYZhF"
              done()
            })
          }
        }
        
        
        it("Should return a User ID greater than 0") {
          waitUntil { done in
            let createUserAPIClient = CreateUserAPIClient()
            createUserAPIClient.createUser(username: "", password: "", recoveryKey: "", firstName: "", lastName: "", email: "", completionHandler: { (response) in
              expect(response.error).to(beNil())
              
              let createUser = response.value!
              expect(createUser.userId) > 0
              expect(createUser.recoveryKey) == "mGPQhM-Xd6G8d-jXofxM-qY6RPd-cpWbaR-ggYZhF"
              done()
            })
          }
        }
      }
    }
  }
}

