//
//  Item.swift
//  ToDoList2
//
//  Created by 宋友勇 on 2025/7/29.
//

import Foundation
import SwiftData

@Model
final class Item {
    var id: UUID
    var timestamp: Date = Date()
    var title: String = ""
    var dueDate: Date = Date()
    var isCheck: Bool = false
    
    init(title: String,dueDate: Date,isCheck:Bool) {
        self.id = UUID()
        self.timestamp = Date()
        self.title = title
        self.dueDate = dueDate
        self.isCheck = isCheck
    }
}
