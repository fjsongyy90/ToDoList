//
//  EditPageView.swift
//  ToDoList2
//
//  Created by 宋友勇 on 2025/7/29.
//

import SwiftUI

struct EditPageView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title:String
    @State private var dueDate:Date
    
    //为nil时候是新增页面
    private var itemToEdit: Item?
    
    private var viewModel: ViewModel{
        itemToEdit == nil ? ViewModel.add : ViewModel.edit
    }
    
    private var titleName:String{
        viewModel == .add ? "新增任务":"修改任务"
    }
    
    init(item: Item? = nil) {
        self.itemToEdit = item
        if let item = item {
            _title = State(initialValue: item.title)
            _dueDate = State(initialValue: item.dueDate)
        } else {
            _title = State(initialValue: "")
            _dueDate = State(initialValue: Date())
        }
        
    }
    
    var body: some View {
        NavigationStack{
            Form{
                Section(header: Text("事项")){
                    TextField("任务内容", text: $title)
                    DatePicker(selection: $dueDate){
                        Text("截止时间")
                    }
                }
            }.navigationTitle(titleName)
                .toolbar{
                    ToolbarItem(placement: .cancellationAction){
                        Button("取消"){
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction){
                        Button("确认") {
                            save()
                            dismiss()
                        }
                    }
                }
        }
    }
    
    private func save() {
        withAnimation {
            //编辑模式
            if let itemToEdit {
                itemToEdit.title = self.title
                itemToEdit.dueDate = self.dueDate
            } else {
                let newItem = Item(title: title, dueDate: dueDate, isCheck: false)
                modelContext.insert(newItem)
            }
        }
    }
    enum ViewModel{
        case add,edit
    }
}

#Preview {
    EditPageView(item: nil)
}
