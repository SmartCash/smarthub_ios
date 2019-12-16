//
//  ReceiveViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 17/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import ToastSwiftFramework

class ReceiveViewController: UIViewController {
  

  @IBOutlet weak var accountIconImageView: UIImageView!
  @IBOutlet weak var accountBalanceLabel: UILabel!
  @IBOutlet weak var accountNameLabel: UILabel!
  @IBOutlet weak var accountAddressLabel: UILabel!
  @IBOutlet weak var chevronImageView: UIImageView!
  @IBOutlet weak var dashedView: UIView!
  @IBOutlet weak var smartAddressButton: UIButton!
  @IBOutlet weak var qrCodeImageView: UIImageView!
  
  var viewModel: MainViewModel!
  
  var accounts = [Wallet]()
  var selectedAccount: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareNavigationController()
    prepareUIElements()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    selectedAccount = UserDefaults.standard.string(forKey: "selected_account")
    if let myWalllets = MyDetails.shared.allWallets {
      accounts = myWalllets
      setInitialSelectedAccount()
    } 
  }
  
  func setInitialSelectedAccount() {
    if let selectedAccount = selectedAccount {
      for i in 0..<accounts.count {
        if accounts[i].address == selectedAccount {
          accountBalanceLabel.text = "Σ \(accounts[i].balance)"
          accountAddressLabel.text = accounts[i].address
          smartAddressButton.setTitle(accounts[i].address, for: .normal)
          accountNameLabel.text = accounts[i].displayName.uppercased()
          let walletImageName = "icon_wallet_\(i%7+1)"
          accountIconImageView.image = UIImage(named: walletImageName)
          qrCodeImageView.kf.indicatorType = .activity
          qrCodeImageView.kf.setImage(with: accounts[i].qrCode)
        }
      }
    } else {
      accountBalanceLabel.text = "Σ \(accounts[0].balance)"
      accountAddressLabel.text = accounts[0].address
      smartAddressButton.setTitle(accounts[0].address, for: .normal)
      accountNameLabel.text = accounts[0].displayName.uppercased()
      let walletImageName = "icon_wallet_\(0%7+1)"
      accountIconImageView.image = UIImage(named: walletImageName)
      qrCodeImageView.kf.indicatorType = .activity
      qrCodeImageView.kf.setImage(with: accounts[0].qrCode)
      selectedAccount = accounts[0].address
    }
  }
  
  override func viewDidLayoutSubviews() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
      self?.dashedView.addDashedBorder()
    }
  }
  
  func prepareUIElements() {
    chevronImageView.tintColor = Color.chevron
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Analytics.setScreenName("Receive Smart", screenClass: nil)
  }
  
  // MARK: Actions
  
  @IBAction func selectAccountAction(_ sender: Any) {
    let storyboard = UIStoryboard(name: "AccountSelection", bundle: nil)
    let accountSelectionViewController = storyboard.instantiateInitialViewController() as! AccountSelectionViewController
    navigationController?.pushViewController(accountSelectionViewController, animated: true)
  }
  
  @IBAction func copyAddressAction(_ sender: Any) {
    if let selectedAccount = selectedAccount {
      UIPasteboard.general.string = selectedAccount
      tabBarController?.view.makeToast("Address copied to clipboard")
      print(selectedAccount)
    }
  }
  
  // MARK: Private
  
  
  
  private func prepareNavigationController() {
    title = "Receive"
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .always
    }
  }
}

extension UIView {
  func addDashedBorder() {
    let color = Color.dashedBorder.cgColor
    
    let shapeLayer:CAShapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
    
    shapeLayer.bounds = shapeRect
    shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = color
    shapeLayer.lineWidth = 2
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    shapeLayer.lineDashPattern = [7, 5]
    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
    
    self.layer.addSublayer(shapeLayer)
  }
}
