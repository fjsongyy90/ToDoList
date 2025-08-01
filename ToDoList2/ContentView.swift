//
//  ContentView.swift
//  ToDoList2
//
//  Created by 宋友勇 on 2025/7/29.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort:\Item.dueDate,order: .reverse) private var items: [Item]
    
    @State private var showEditPage = false
    @State private var itemToEdit: Item?
    
    @State private var editMode:EditMode = .inactive
    @State private var selection = Set<Item.ID>()
    @State private var showOnlyUnchecked = true
    
    var filterItems: [Item] {
        if showOnlyUnchecked {
            return items.filter{
                !$0.isCheck
            }
        } else {
            return items
        }
    }
    
    var body: some View {
            NavigationView{
                List(selection: $selection){
                    ForEach(filterItems){i in
                        SingleCardView(item:i)
                    }
                    .onDelete(perform: deleteItem)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }.navigationTitle("提醒事项")
                    .navigationBarTitleDisplayMode(.inline)
                    .listStyle(.plain)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                self.showOnlyUnchecked.toggle()
                            }){Image(systemName: self.showOnlyUnchecked ? "eye.slash" : "eye")
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                showEditPage = true
                            }){Image(systemName: "plus")}
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            EditButton()
                        }
                        ToolbarItemGroup(placement: .bottomBar) {
                            if self.editMode == .active{
                                Spacer()
                                Button(role: .destructive) {
                                    deleteSelectItem()
                                }
                                label: {
                                    Text("删除：\(selection.count)个")
                                }
                                .disabled(selection.isEmpty)
                            }
                        }
                    }
                    .sheet(isPresented: $showEditPage){
                        EditPageView()
                    }
                    .environment(\.editMode, $editMode)
            }
                
        }
    private func deleteItem(at offset:IndexSet) {
        withAnimation {
            for index in offset {
                let item = filterItems[index]
                NotificationManager.shared.cacelNotification(for: item)
                self.modelContext.delete(item)
            }
        }
    }
    
    private func deleteSelectItem() {
        let selectionItems = items.filter { selection.contains($0.id)
        }
        for i in selectionItems {
            NotificationManager.shared.cacelNotification(for: i)
            self.modelContext.delete(i)
        }
    }
    
}

struct SingleCardView: View {
    var item: Item
    @State private var showEditPage: Bool = false
    
    var body: some View {
        HStack {
            Button {
                self.showEditPage = true
            } label: {
                HStack {
                    Rectangle()
                        .foregroundStyle(.blue)
                        .frame(width: 8)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.title)
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                        Text(item.dueDate,format: .dateTime.month().day().hour().minute())
                            .foregroundColor(Color.gray)
                    }
                    .padding()
                    Spacer(minLength: 6)
                }
            }.sheet(isPresented: $showEditPage){
                EditPageView(item: item)
            }.buttonStyle(.plain)
            
            Image(systemName: item.isCheck ? "checkmark.square.fill":"square")
                .padding(.trailing)
                .imageScale(.large)
                .onTapGesture {
                    withAnimation {
                        item.isCheck.toggle()
                    }
                    if item.isCheck{
                        NotificationManager.shared.cacelNotification(for: item)
                    } else {
                        NotificationManager.shared.scheduleNotification(for: item)
                    }
                }
            
        }
        .frame(height: 80)
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 10,x:0,y:10)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Item.self,  configurations:config)
        let itemArray = [
            Item(title: "学习", dueDate: Date().addingTimeInterval(-3600), isCheck: false),
            Item(title: "写作业", dueDate: Date().addingTimeInterval(-1800), isCheck: false),
            Item(title: "复习", dueDate: Date(), isCheck: false)
        ]
        let context = container.mainContext
        itemArray.forEach{i in
            context.insert(i)
        }
        return NavigationStack {
            ContentView()
                .modelContainer(container)
        }
    }catch {
        print("预览数据加载失败")
        return Text("预览数据加载失败")
    }
}
