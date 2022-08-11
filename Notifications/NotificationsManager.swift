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
  
  func scheduleNotification(notificationTitle: String) {
    let content = UNMutableNotificationContent()
    content.title = notificationTitle
    content.body = "This is example how to create \(notificationTitle)"
    content.sound = UNNotificationSound.default
    content.badge = 1
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
  
    // для каждого уведомления нужен ID
    let id = "Local Notification"
    let notificationRequest = UNNotificationRequest(
      identifier: id,
      content: content,
      trigger: trigger
    )
    notificationCenter.add(notificationRequest) { error in
      if let error = error {
        print("Error \(error.localizedDescription)")
      }
    }
  }
  
  func scheduleNotificationsWithActions(notificationTitle: String) {
    let content = UNMutableNotificationContent()
    
    // 2 //
    let userAction = "UserActions"
    // 2 //
    
    content.title = notificationTitle
    content.body = "This is example how to create \(notificationTitle)"
    content.sound = UNNotificationSound.default
    content.badge = 1
    content.categoryIdentifier = userAction
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
  
    // для каждого уведомления нужен ID
    let id = "Local Notification"
    let notificationRequest = UNNotificationRequest(
      identifier: id,
      content: content,
      trigger: trigger
    )
    notificationCenter.add(notificationRequest) { error in
      if let error = error {
        print("Error \(error.localizedDescription)")
      }
    }
    
    // 1 //
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
    // 1 //
    
    // 2 //
    let category = UNNotificationCategory(
      identifier: userAction,
      actions: [snoozeAction, deleteAction],
      intentIdentifiers: [],
      options: []
    )
    // 2 //
    
    // 3 //
    notificationCenter.setNotificationCategories([category])
    // 3 //
  }
  
  func scheduleNotificationsWithContent(notificationTitle: String) {
    let content = UNMutableNotificationContent()
    content.title = notificationTitle
    content.body = "This is example how to create \(notificationTitle)"
    content.sound = UNNotificationSound.default
    content.badge = 1
    
    if let attachment = UNNotificationAttachment.create(
      image: UIImage(named: "Xcode_icon") ?? UIImage(),
      options: nil
    ) {
      content.attachments = [attachment]
    }
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
  
    // для каждого уведомления нужен ID
    let id = "Local Notification"
    let notificationRequest = UNNotificationRequest(
      identifier: id,
      content: content,
      trigger: trigger
    )
    notificationCenter.add(notificationRequest) { error in
      if let error = error {
        print("Error \(error.localizedDescription)")
      }
    }
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
    defer { completionHandler() }
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
      scheduleNotification(notificationTitle: "Snoozing")
    case "Delete":
      print("Delete Action")
    default:
      print("Unknown Action")
    }
  }
}

extension UNNotificationAttachment {
  
  static func create(image: UIImage, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
    let identifier = ProcessInfo.processInfo.globallyUniqueString
    let fileManager = FileManager.default
    let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
    let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
    do {
      try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
      let imageFileIdentifier = identifier+".png"
      let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
      let imageData = UIImage.pngData(image)
      try imageData()?.write(to: fileURL)
      let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL, options: options)
      return imageAttachment
    } catch {
      print("error " + error.localizedDescription)
    }
    return nil
  }
}
