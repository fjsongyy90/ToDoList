//
//  ItemViewModel.swift
//  ToDoList2
//
//  Created by 宋友勇 on 2025/7/29.
//

import Foundation
import SwiftData
import SwiftUI
import os.log

class ItemViewModel: ObservableObject {
    
    private var modelContext: ModelContext
    
    @Published var title = ""
    @Published var dueDate = Date()
    @Published var isCheck = false
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
}
