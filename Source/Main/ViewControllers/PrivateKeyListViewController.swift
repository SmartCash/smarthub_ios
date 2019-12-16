//
//  PrivateKeyListViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 18/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class PrivateKeyListViewController: UIViewController {
  
  @IBOutlet weak var privateKeysTextView: UITextView!
  
  var privateKeysText: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    privateKeysTextView.text = privateKeysText
    
      title = "List of Private Keys"
      navigationController?.navigationBar.isTranslucent = false
      navigationController?.navigationBar.barTintColor = Color.smartYellow
      navigationController?.navigationBar.tintColor = Color.smartBlack
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Color.smartBlack]
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Analytics.setScreenName("Private Key List", screenClass: nil)
  }
}
