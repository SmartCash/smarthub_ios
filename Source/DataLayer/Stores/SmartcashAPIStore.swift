//
//  SmartcashAPIStore .swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 11/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import Alamofire

class SmartcashAPIStore {
  
  let myDetailsAPIClient: MyDetailsAPIClient
  let authStore: AuthStore
  let sendPaymentAPIClient: SendPaymentAPIClient
  let addressBookAPIClient: AddressBookAPIClient
  let castVoteAPIClient: CastVoteAPIClient
  
  init(myDetailsAPIClient: MyDetailsAPIClient = MyDetailsAPIClient(),
       authStore: AuthStore = AuthStore(),
       sendPaymentAPIClient: SendPaymentAPIClient = SendPaymentAPIClient(),
       addressBookAPIClient: AddressBookAPIClient = AddressBookAPIClient(),
       castVoteAPIClient: CastVoteAPIClient = CastVoteAPIClient()) {
    self.myDetailsAPIClient = myDetailsAPIClient
    self.authStore = authStore
    self.sendPaymentAPIClient = sendPaymentAPIClient
    self.addressBookAPIClient = addressBookAPIClient
    self.castVoteAPIClient = castVoteAPIClient
  }
  
  func getWallet(force: Bool = false, completionHandler: @escaping (Result<MyDetailsAPI>) -> Void) {
    if let wallets = authStore.keychainClient.wallets, !force {
      MyDetails.shared.allWallets = wallets
      let walletsAPI = MyDetailsAPI(wallets: wallets, is2FAEnabled: authStore.is2FAEnabled(), status: "", isValid: true)
      completionHandler(Result.success(walletsAPI))
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      if let accessToken = authStore.accessToken {
        myDetailsAPIClient.get(accessToken: accessToken, completionHandler: { response in
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
          completionHandler(response.result)
        })
      }
    } else {
      if let accessToken = authStore.accessToken {
        myDetailsAPIClient.get(accessToken: accessToken, completionHandler: { response in
          completionHandler(response.result)
        })
      }
    }
  }
  
  func sendPayment(from: String, to: String, amount: Decimal, userKey: String, completionHandler: @escaping (Result<Any>) -> Void) {
    if let accessToken = authStore.accessToken {
      sendPaymentAPIClient.pay(accessToken: accessToken, from: from, to: to, amount: amount, userKey: userKey, completionHandler: { response in
        response.result.ifFailure {
          do {
            var item = try JSONDecoder().decode(SmartCashAPIError.self, from: response.data!)
            completionHandler(.failure(item))
          } catch {
            completionHandler(response.result)
          }
        }
        completionHandler(response.result)
      })
    }
  }
  
  func getAddressBook(completionHandler: @escaping (Result<AddressBookAPI>) -> Void) {
    if let accessToken = authStore.accessToken {
      addressBookAPIClient.getContacts(accessToken: accessToken, completionHandler: { response in
        completionHandler(response.result)
      })
    }
  }
  
  func createAddressinAddressBook(name: String, address: String, completionHandler: @escaping (Result<Any>) -> Void) {
    if let accessToken = authStore.accessToken {
      addressBookAPIClient.createContact(accessToken: accessToken, name: name, address: address, completionHandler: { response in
        completionHandler(response.result)
      })
    }
  }
  
  func deleteAddressinAddressBook(id: Int, completionHandler: @escaping (Result<Any>) -> Void) {
    if let accessToken = authStore.accessToken {
      addressBookAPIClient.deleteContact(accessToken: accessToken, id: id, completionHandler: { response in
        completionHandler(response.result)
      })
    }
  }
  
  func castVote(proposalId: Int, proposalUrl: String, from: String, voteType: String, userKey: String, completionHandler: @escaping (Result<Any>) -> Void) {
    if let accessToken = authStore.accessToken {
      castVoteAPIClient.vote(accessToken: accessToken, proposalId: proposalId, proposalUrl: proposalUrl, from: from, voteType: voteType, userKey: userKey, completionHandler: { response in
        completionHandler(response.result)
      })
    }
  }
}
