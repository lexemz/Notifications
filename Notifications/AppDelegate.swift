//
//  AppDelegate.swift
//  Notifications
//
//  Created by Alexey Efimov on 21.06.2018.
//  Copyright © 2018 Alexey Efimov. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  let notificationCenter = UNUserNotificationCenter.current()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    requestAuthorization()
    return true
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Очистить значок уведомлений
    UIApplication.shared.applicationIconBadgeNumber = 0
  }

  // вызывается при каждом запуске приложения
  func requestAuthorization() {
    notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if granted {
        print("Permission Granted")
        self.getNotificationsSettings()
      } else {
        print("Something going wrong: \(String(describing: error?.localizedDescription))")
      }
    }
  }
  
  func getNotificationsSettings() {
    notificationCenter.getNotificationSettings { settings in
      print(settings)
    }
  }
  
  func scheduleNotification(notificationType: String) {
    let content = UNMutableNotificationContent()
    
    content.title = notificationType
    content.body = "This is example how to create \(notificationType)"
    content.sound = UNNotificationSound.default
    content.badge = 1
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
  
    // для каждого уведомления нужен ID
    let id = "Local Notification"
    let notificationRequest = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
    notificationCenter.add(notificationRequest) { error in
      if let error = error {
        print("Error \(error.localizedDescription)")
      }
    }
  }
}
