//
//  LoginAPITests .swift
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

@testable import SmartcashWallet

class LoginAPIClientTest: QuickSpec {
  
  override func spec() {
    
    beforeEach {
      stub(condition: pathEndsWith(LoginRouter.login(username: "stub", password: "stub") .path)) { _ in
        return OHHTTPStubsResponse(
          fileAtPath: OHPathForFile("Login.json", type(of: self))!,
          statusCode: 200,
          headers: ["Content-Type":"application/json"]
        )
      }
    }
    
    afterEach {
      OHHTTPStubs.removeAllStubs()
    }
    
    describe("Login API Client") {
      
      context("When user tries to Login") {
        
        it("It should return the Access and Refresh Tokens") {
          waitUntil { done in
            let loginAPIClient = LoginAPIClient()
            loginAPIClient.login(username: "", password: "", completionHandler: { (response) in
              expect(response.error).to(beNil())
              
              let login = response.value!
              expect(login.accessToken) == "OIZpRB_XsYYs1VsqLmHPJ4JiZrckgug4nO_W3ierAgD62F1KOzQa96VilHFl4tQOaoU8od125u33mfv6OOC7xSRzSb2QbBp_HGcRN3kSrUtHDeeptuqBRgJ62Dz0wY32wak4zMUgv21e8KoCmtTq-Ph2sLKeWtroLIoRPRm3jcnRG4n4-EcL7L9Wny8wAMwVufSxSqcw4VNX6xQrUpOLqKTg82FR2vbqi8TaO2hOO6_ZUBhRHZlGrgVO-c0vPzSJ6pwfxd6mSmWiPJ3JpJRmU87jd_iC59VLiHpKs_BxrZa4CIp0pctgD8Lrp97fmtL5L0Z3cMz93_6s4KNuQz0HbHTVpK6jXu2SVWb_zadv8W34z6cuy-bUR9U3DpUZZNe9aQQ5VgxoyAkM4kfE9SVS_A"
              expect(login.refreshToken) == "cba652a9-73ed-4d16-b71a-4084dc03457e"
              done()
            })
          }
        }
      }
    }
  }
}
