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
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
