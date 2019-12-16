//
//  AppStartScreenSwicther .swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 10/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Foundation
import UIKit

class AppStartScreenSwitcher {
  
  let authStore: AuthStore
  let smartcashAPIStore: SmartcashAPIStore

  init(authStore: AuthStore = AuthStore(),
       smartcashAPIStore: SmartcashAPIStore = SmartcashAPIStore()) {
    self.authStore = authStore
    self.smartcashAPIStore = smartcashAPIStore
  }
  
  func asdf() {
    if authStore.isAccessTokenValid {
      authStore.requestDeviceAuthentication { [weak self] (isAuthenticated, error) in
        if isAuthenticated {
          DispatchQueue.main.async {
            self?.switchToMainScreen()
          }
        } else {
          DispatchQueue.main.async {
            self?.switchToWelcomeScreen()
          }
        }
      }
    } else {
      switchToWelcomeScreen()
    }
  }
  
  func determineAndSetAppFirstScreen() {
    
//    switchToVoting()
//    return
//    authStore.keychainClient.accessToken = nil
    switchToWelcomeScreen()
        return
//    authStore.keychainClient.accessToken = nil
    
    // 0. If user is currently logged in
    if authStore.isAccessTokenValid {
      switchToMainScreen()
      return
    }
    switchToWelcomeScreen()
    
//    //  1. If Username and Password Found.
//    if authStore.isUsernameAndPasswordAvailable {
////      autoLoginUser()
//      switchToLoginScreen()
//      return
//    }
//
//    //  2. If there is no access token, then goto Welcome screen.
//    if !authStore.isUsernameAndPasswordAvailable {
////      switchToCreateUserScreen()
//      switchToWelcomeScreen()
//      return
//    }
  }
  
  @objc private func resetToLoginScreen() {
    switchToLoginScreen()
  }
  
  func switchToVoting() {
    let tabController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController
    var navController = tabController?.viewControllers?[4] as? UINavigationController
    var mainController = navController?.viewControllers.first as? VotingViewController
    
    guard mainController == nil else {
      return
    }
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let mainTabController = storyboard.instantiateInitialViewController() as? UITabBarController
    mainTabController?.selectedIndex = 3
    navController = mainTabController?.viewControllers?[4] as? UINavigationController
    mainController = navController?.viewControllers.first as? VotingViewController
    
    setWindowRootViewController(mainTabController!, animated: false)
  }
  
  func switchToWelcomeScreen() {
    let storyboard = UIStoryboard(name: "Auth", bundle: nil)
    let identifier = String(describing: WelcomeViewController.self)
    let loginViewController = storyboard.instantiateViewController(withIdentifier: identifier)
    
    // If user is already in the login screen, he/she stays there
    if let navController = UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController {
      
      if navController.viewControllers.count > 1 {
        // If user is already in the login screen, he/she stays there
        if navController.viewControllers[1] as? LoginViewController != nil {
          return
        }
        
        // If user is already in the account creation screen, he/she stays there
        if navController.viewControllers[1] as? CreateUserViewController != nil {
          return
        }
      }
    }

    setWindowRootViewController(loginViewController, animated: true)
  }
  
  func switchToLoginScreen() {

    let storyboard = UIStoryboard(name: "Auth", bundle: nil)
    let welcomeIdentifier = String(describing: WelcomeViewController.self)
    let loginIdentifier = String(describing: LoginViewController.self)
    let loginViewController = storyboard.instantiateViewController(withIdentifier: loginIdentifier)
    loginViewController.title = "Login"

    
    // Make sure we are not at the login
    if let setNavController = UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController {
      guard setNavController.viewControllers[1] as? LoginViewController == nil else { return }
    }
    
    
    if let welcomeNavController = storyboard.instantiateViewController(withIdentifier: welcomeIdentifier) as? UINavigationController {
      if let welcomeViewController = welcomeNavController.viewControllers.first as? WelcomeViewController {
        
        welcomeViewController.title = "Welcome"
        welcomeViewController.navigationController?.isNavigationBarHidden = false
        welcomeViewController.navigationController?.navigationBar.isTranslucent = false
        welcomeViewController.navigationController?.navigationBar.barTintColor = Color.smartYellow
        welcomeViewController.navigationController?.navigationBar.tintColor = Color.smartBlack
        welcomeViewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Color.smartBlack]
        
        
        setWindowRootViewController(welcomeNavController, animated: true)
        welcomeNavController.pushViewController(loginViewController, animated: false)
      }
    }
    
    
    
//    let storyboard = UIStoryboard(name: "Auth", bundle: nil)
//    let identifier = String(describing: LoginViewController.self)
//    let loginViewController = storyboard.instantiateViewController(withIdentifier: identifier)
//
//    guard UIApplication.shared.delegate?.window??.rootViewController as? LoginViewController == nil else { return }
//
//    setWindowRootViewController(loginViewController, animated: true)
  }
  
  func switchToBlankScreen(message: String) {
    
    let storyboard = UIStoryboard(name: "Blank", bundle: nil)
    let identifier = String(describing: BlankViewController.self)
    let blankViewController = storyboard.instantiateViewController(withIdentifier: identifier) as! BlankViewController
    blankViewController.showLoadingView(message: message)
    
    setWindowRootViewController(blankViewController, animated: true)
  }
  
  func switchToMainScreen() {
    //Move to Main Screen only if the currrently visible screen is the MainViewController.
    let tabController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController
    var navController = tabController?.viewControllers?[1] as? UINavigationController
    var mainController = navController?.viewControllers.first as? MainViewController
    
    guard mainController == nil else {
      return
    }
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let mainTabController = storyboard.instantiateInitialViewController() as? UITabBarController
    mainTabController?.selectedIndex = 0
    navController = mainTabController?.viewControllers?[1] as? UINavigationController
    mainController = navController?.viewControllers.first as? MainViewController
  
    setWindowRootViewController(mainTabController!, animated: false)
  }
  
  func switchToCreateUserScreen() {
    
    let storyboard = UIStoryboard(name: "Auth", bundle: nil)
    let welcomeIdentifier = String(describing: WelcomeViewController.self)
    let createIdentifier = String(describing: CreateUserViewController.self)
    let createUserViewController = storyboard.instantiateViewController(withIdentifier: createIdentifier)
    
    
    // Make sure we are not at creation
    if let setNavController = UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController {
      guard setNavController.viewControllers[1] as? CreateUserViewController == nil else { return }
    }
    
    
    if let welcomeNavController = storyboard.instantiateViewController(withIdentifier: welcomeIdentifier) as? UINavigationController {
      if let welcomeViewController = welcomeNavController.viewControllers.first as? WelcomeViewController {
        setWindowRootViewController(welcomeNavController, animated: true)
        welcomeNavController.pushViewController(createUserViewController, animated: false)
      }
    }

//    let storyboard = UIStoryboard(name: "Auth", bundle: nil)
//    let identifier = String(describing: CreateUserViewController.self)
//    let createUserViewController = storyboard.instantiateViewController(withIdentifier: identifier)
//    
//    setWindowRootViewController(createUserViewController, animated: false)
  }
  
  func autoLoginUser() {
    
//    let username = authStore.keychainClient.username!
//    let password = authStore.keychainClient.userPassword!
//
//    authStore.login(username: username, password: password, completionHandler: { [weak self] result in
//      switch result {
//      case .success:
//        self?.smartcashAPIStore.getWallet(completionHandler: { result in
//          switch result {
//          case .success:
//            self?.switchToMainScreen()
//          case .failure:
//            self?.switchToLoginScreen()
//          }
//        })
//        self?.switchToBlankScreen(message: "Loading your wallets...")
//      case .failure:
//        self?.switchToLoginScreen()
//      }
//    })
//    self.switchToBlankScreen(message: "Logging you in...")
  }
  
  // MARK: Private
  
  private func setWindowRootViewController(_ viewController: UIViewController, animated: Bool) {
    guard case let window?? = UIApplication.shared.delegate?.window else { return }
    
    let duration = animated ? 0.3 : 0
    UIView.transition(with: window, duration: duration, options: .transitionCrossDissolve, animations: {
      window.rootViewController = viewController
    }, completion: nil)
  }
}
