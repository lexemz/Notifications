//
//  AppDelegate.swift
//  Notifications
//
//  Created by Alexey Efimov on 21.06.2018.
//  Copyright © 2018 Alexey Efimov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    NotificationsManager.shared.requestAuthorization()
    return true
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Очистить значок уведомлений
    UIApplication.shared.applicationIconBadgeNumber = 0
  }

}
