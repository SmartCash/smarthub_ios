//
//  MyWalletAPITests .swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 11/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import Nimble
import Quick
import OHHTTPStubs
import Alamofire

@testable import SmartcashWallet

class MyWalletAPIClientTest: QuickSpec {
  
  override func spec() {
    
    beforeEach {
      stub(condition: pathEndsWith(MyWalletRouter.get(accessToken: "stub").path)) { _ in
        return OHHTTPStubsResponse(
          fileAtPath: OHPathForFile("MyWallet.json", type(of: self))!,
          statusCode: 200,
          headers: ["Content-Type":"application/json"]
        )
      }
    }
    
    afterEach {
      OHHTTPStubs.removeAllStubs()
    }
    
    describe("My Wallet API Client") {
      
      context("When user tries to retrieve wallet") {
        
        it("Should have my wallet address") {
          waitUntil { done in
            let myWalletAPIClient = MyWalletAPIClient()
            myWalletAPIClient.get(accessToken: "stub", completionHandler: { (response) in
              expect(response.error).to(beNil())
              
              let myWallet = response.value!
//              expect(myWallet.address) == "SZVeUXEa3XYoapGkx5UWZqpjbdmS52gEJR"
              expect(1) == 2
              done()
            })
          }
        }
      }
    }
  }
}
