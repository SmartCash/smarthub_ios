//
//  SettingsViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 14/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class SettingsViewController: UITableViewController {
  
  @IBOutlet weak var chevronImage2FA: UIImageView!
  @IBOutlet weak var chevronImageImport: UIImageView!
  @IBOutlet weak var chevronImageExport: UIImageView!
  @IBOutlet weak var chevronImageLogoff: UIImageView!

  var viewModel: SettingsViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = SettingsViewModel(viewController: self)
    
    prepareUIElements()
    prepareNavigationController()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Analytics.setScreenName("Settings", screenClass: nil)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 && indexPath.row == 0 {
      viewModel.twoFactorAuthentication()
    }
    if indexPath.section == 1 && indexPath.row == 0 {
      viewModel.importPrivateKey()
    }
    if indexPath.section == 1 && indexPath.row == 1 {
      viewModel.exportPrivateKey()
    }
    if indexPath.section == 2 && indexPath.row == 0 {
      viewModel.logOff()
    }
    
  }
  
  // MARK: Actions
  
  @IBAction func twoFAAction() {
    viewModel.twoFactorAuthentication()
  }
  
  @IBAction func importPrivateKeyAction() {
    viewModel.importPrivateKey()
  }
  
  @IBAction func exportPrivateKeyAction() {
    viewModel.exportPrivateKey()
  }
  
  @IBAction func logOffAction() {
    viewModel.logOff()
  }
  // MARK: Private
  
  private func prepareUIElements() {
 
  }
  
  private func prepareNavigationController() {
    title = "Settings"
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .always
    }
  }
}

// MARK: SettingsViewControllerProtocol

extension SettingsViewController: SettingsViewControllerProtocol {
  func displayError(message: String) {
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  func enable2FA() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let identifier = String(describing: Enable2FAViewController.self)
    if let enable2FAViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Enable2FAViewController {
      let enable2FAViewModel = Enable2FAViewModel(viewController: enable2FAViewController, delegate: self)
      enable2FAViewController.viewModel = enable2FAViewModel
      navigationController?.pushViewController(enable2FAViewController, animated: true)
    }
  }
  
  func disable2FA() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let identifier = String(describing: Disable2FAViewController.self)
    if let disable2FAViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Disable2FAViewController {
      let disable2FAViewModel = Disable2FAViewModel(viewController: disable2FAViewController, delegate: self)
      disable2FAViewController.viewModel = disable2FAViewModel
      navigationController?.pushViewController(disable2FAViewController, animated: true)
    }
  }
  
  func displayImportPrivateKeyScreen() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let identifier = String(describing: ImportPrivateKeyViewController.self)
    if let importPrivateKeyViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? ImportPrivateKeyViewController {
      let importPrivateKeyViewModel = ImportPrivateKeyViewModel(viewController: importPrivateKeyViewController)
      importPrivateKeyViewController.viewModel = importPrivateKeyViewModel
      navigationController?.pushViewController(importPrivateKeyViewController, animated: true)
    }
  }
  
  func displayExportPrivateKeyScreen() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let identifier = String(describing: ExportPrivateKeyViewController.self)
    if let exportPrivateKeyViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? ExportPrivateKeyViewController {
      let exportPrivateKeyViewModel = ExportPrivateKeyViewModel(viewController: exportPrivateKeyViewController)
      exportPrivateKeyViewController.viewModel = exportPrivateKeyViewModel
      navigationController?.pushViewController(exportPrivateKeyViewController, animated: true)
    }
  }
  
  func logOffCompleted() {
    (UIApplication.shared.delegate as? AppDelegate)?.appScreenSwitcher.determineAndSetAppFirstScreen()
  }
}

extension SettingsViewController: TwoFAUpdateDelegate {
  func update2FAStatus(isEnabled: Bool) {
    view.makeToast(isEnabled ? "2FA Enabled Successfully" : "2FA Disabled Successfully", duration: 3.0, position: .center)
  }
}
