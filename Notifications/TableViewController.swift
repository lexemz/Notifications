//
//  TableViewController.swift
//  LocalNotification
//
//  Created by Debash on 05.06.2018.
//  Copyright © 2018 swiftbook.ru. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
  let notifications = ["Local Notification",
                       "Local Notification with Action",
                       "Local Notification with Content",
//                       "Push Notification with  APNs",
//                       "Push Notification with Firebase",
//                       "Push Notification with Content"
  ]

  // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notifications.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

    cell.textLabel?.text = notifications[indexPath.row]
    cell.textLabel?.textColor = .white
        
    return cell
  }
    
  // MARK: - Table View Delegate
    
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.textLabel?.textColor = .red
        
    let notificationType = notifications[indexPath.row]
    

        
    let alert = UIAlertController(title: notificationType,
                                  message: "After 3 seconds " + notificationType + " will appear",
                                  preferredStyle: .alert)
    
    var alertAction: ((UIAlertAction) -> Void)?
    
    switch notificationType {
    case "Local Notification":
      alertAction = { _ in
        NotificationsManager.shared.scheduleNotification(notificationTitle: notificationType)
      }
    case "Local Notification with Action":
      alertAction = { _ in
        NotificationsManager.shared.scheduleNotificationsWithActions(notificationTitle: notificationType)
      }
    case "Local Notification with Content":
      break
    default:
      print("Unknown Notification Type")
    }
        
    let okAction = UIAlertAction(title: "OK", style: .default, handler: alertAction)
        
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
  }
    
  override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.textLabel?.textColor = .white
  }
}
