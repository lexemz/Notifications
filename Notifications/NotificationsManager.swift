//
//  NotificationsManager.swift
//  Notifications
//
//  Created by Igor Buzykin on 11.08.2022.
//  Copyright © 2022 Alexey Efimov. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsManager: NSObject {
  
  static let shared = NotificationsManager()
  
  private override init() {
    super.init()
    notificationCenter.delegate = self
  }
  
  let notificationCenter = UNUserNotificationCenter.current()
  // вызывается при каждом запуске приложения
  func requestAuthorization() {
    notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
      if granted {
        print("Permission Granted")
        self.getNotificationsSettings()
      } else {
        print("User dont grant permissions")
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
    let userAction = "UserActions"
    
    content.title = notificationType
    content.body = "This is example how to create \(notificationType)"
    content.sound = UNNotificationSound.default
    content.badge = 1
    content.categoryIdentifier = userAction
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
  
    // для каждого уведомления нужен ID
    let id = "Local Notification"
    let notificationRequest = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
    notificationCenter.add(notificationRequest) { error in
      if let error = error {
        print("Error \(error.localizedDescription)")
      }
    }
    
    let snoozeAction = UNNotificationAction(
      identifier: "Snooze",
      title: "Snooze",
      options: []
    )
    let deleteAction = UNNotificationAction(
      identifier: "Delete",
      title: "Delete",
      options: [.destructive]
    )
    let category = UNNotificationCategory(
      identifier: userAction,
      actions: [snoozeAction, deleteAction],
      intentIdentifiers: [],
      options: []
    )
    
    notificationCenter.setNotificationCategories([category])
  }
}

extension NotificationsManager: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .sound])
    } else {
      completionHandler([.alert, .sound])
    }
  }
  
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    if response.notification.request.identifier == "Local Notification" {
      print(response.notification.request.content.body)
    }
    
    switch response.actionIdentifier {
    case UNNotificationDismissActionIdentifier:
      print("Dismiss Notification")
    case UNNotificationDefaultActionIdentifier:
      print("Default Action")
    case "Snooze":
      print("Snooze Action")
      scheduleNotification(notificationType: "Snoozing")
    case "Delete":
      print("Delete Action")
    default:
      print("Unknown Action")
    }
    completionHandler()
  }
}
