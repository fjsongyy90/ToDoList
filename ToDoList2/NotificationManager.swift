//
//  NotificationManager.swift
//  ToDoList2
//
//  Created by 宋友勇 on 2025/8/1.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private init(){}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]){
            granted, error in
            if granted {
                print("通知权限已授予")
            } else if let error = error{
                print("通知权限开通失败:\(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotification(for item:Item) {
        let content = UNMutableNotificationContent()
        content.title = "提醒事项"
        content.subtitle = item.title
        content.sound = .default
        
        guard item.dueDate > Date() else {return}
        let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: item.dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let requset = UNNotificationRequest(identifier: item.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(requset){
            error in
            if let error = error{
                print ("安排通时时出错：\(error.localizedDescription)")
            } else {
                print("已成功为\(item.title)安排通知")
            }
        }
    }
    
    func cacelNotification(for item:Item){
        let identifier = item.id.uuidString
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("已取消\(item.title)的通知")
    }
}
