//
//  AppDelegate.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 7/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  let appScreenSwitcher: AppStartScreenSwitcher = AppStartScreenSwitcher()


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    if !isRunningTests() {
      setupWindow()
    }
    setNavigationBarProperties()
    FirebaseApp.configure()
    appScreenSwitcher.asdf()
    appScreenSwitcher.determineAndSetAppFirstScreen()
//    appScreenSwitcher.switchToVoting()
    UIApplication.configureLinearNetworkActivityIndicatorIfNeeded()
    
    return true
  }
  
  

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    if !isRunningTests() {
      //AppConfigStore.shared.updateDebugSettings()
//      appScreenSwitcher.determineAndSetAppFirstScreen()
    }
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  fileprivate func isRunningTests() -> Bool {
    return NSClassFromString("XCTestCase") != nil
  }
  
  fileprivate func setupWindow() {
    window = UIWindow()
    let storyboard = UIStoryboard(name: "Blank", bundle: nil)
    let initialViewController = storyboard.instantiateViewController(withIdentifier: "BlankViewController")
    
    self.window?.rootViewController = initialViewController
    
    
    window?.makeKeyAndVisible()
  }
  
  private func setNavigationBarProperties() {
    if #available(iOS 11.0, *) {
      UINavigationBar.appearance().prefersLargeTitles = true
      UINavigationBar.appearance().largeTitleTextAttributes = [
        NSAttributedString.Key.foregroundColor: Color.smartBlack,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 31, weight: UIFont.Weight.bold)
      ]
    }
    UINavigationBar.appearance().isTranslucent = false
    UINavigationBar.appearance().barTintColor = Color.smartYellow
    UINavigationBar.appearance().tintColor = Color.smartBlack
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: Color.smartBlack]
  }
}
