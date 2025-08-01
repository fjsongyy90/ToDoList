//
//  ItemService.swift
//  ToDoList2
//
//  Created by 宋友勇 on 2025/7/29.
//

import Foundation
import SwiftData
import OSLog

class ItemService {
    
    private static let logger = Logger(subsystem: "com.yourapp.ToDoList2", category: "Item")

    
    static func createItem(
            title: String,
            dueDate: Date,
            isCheck: Bool,
            modelContext: ModelContext
        ) -> Item {
            let newItem = Item(
                title: title,
                dueDate: dueDate,
                isCheck: isCheck
            )
            
            modelContext.insert(newItem)
            
            do {
                try modelContext.save()
                logger.info("成功创建: \(title)")
            } catch {
                logger.error("创建item出错: \(error.localizedDescription)")
            }
            
            return newItem
        }
    
}
