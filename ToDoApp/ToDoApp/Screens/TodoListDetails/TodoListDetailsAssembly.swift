//
//  TodoListAssembly.swift
//  ToDoApp
//
//  Created by Никита Китаев on 27.06.2024.
//

import SwiftUI

enum TodoListDetailsAssembly {
  enum TodoListDetailsAssemblyError: Error {
    case serviceCreationError
  }
  
  static func build() -> TodoListDetails {
    let viewModel = TodoListDetailsViewModel()
    
    var item1 = TodoItemModel(id: "1dc3b91c-f3d9-4954-b3fb-0b000211b9c3", text: "Sample Task 1", importance: .medium, deadline: Date.init(timeIntervalSince1970: 3), isDone: true, createdAt: Date.now, color: "#FFFFFF")
    var item2 = TodoItemModel(id: "e4726f09-18c2-4864-84df-6f226fdacc8a", text: "Sample Task 2", importance: .low, deadline: Date(timeIntervalSinceNow: 1036800), isDone: true, createdAt: Date.now, color: "#FFFFFF")
    var item3 = TodoItemModel(id: "7f55b51d-64df-4b5c-a1a5-6878b33f9f68", text: "Sample Task 3", importance: .medium, deadline: Date.init(timeIntervalSince1970: 1719861982), isDone: true, createdAt: Date.now, color: "#FFFFFF")
    var item4 = TodoItemModel(id: "30325f5e-0c3d-4efd-aa91-556c28958de1", text: "Sample Task 4", importance: .low, deadline: nil, isDone: false, createdAt: Date.now, color: "#FFFFFF")
    var item5 = TodoItemModel(id: "79233728-4ea3-4cc7-ac29-168da6987d2d", text: "Sample Task 5", importance: .low, deadline: nil, isDone: true, createdAt: Date.now, color: "#FFFFFF")
    var item6 = TodoItemModel(id: "79233728-4ea3-4cc7-ac29-168da6987d23", text: "Sample Task 6", importance: .low, deadline: nil, isDone: true, createdAt: Date.now, color: "#FFFFFF")
    var item7 = TodoItemModel(id: "79233728-4ea3-4cc7-ac29-168da6987d2f", text: "Sample Task 7", importance: .low, deadline: Date.tomorrow(), isDone: true, createdAt: Date.now, color: "#FFFFFF")
    var item8 = TodoItemModel(id: "79233728-4ea3-4cc7-ac29-168da6987d2l", text: "Sample Task 8", importance: .low, deadline: Date.tomorrow(), isDone: true, createdAt: Date.now, color: "#FFFFFF")
    var item9 = TodoItemModel(id: "79233728-4ea3-4cc7-ac29-168da6987d2p", text: "Sample Task 9", importance: .low, deadline: Date.tomorrow(), isDone: false, createdAt: Date.now, color: "#FFFFFF")
    var item10 = TodoItemModel(id: "79233728-4ea3-4cc7-ac29-168da6987d2q", text: "Sample Task 10", importance: .low, deadline: Date.tomorrow(), isDone: false, createdAt: Date.now, color: "#FFFFFF")
    var item11 = TodoItemModel(id: "79233728-4ea3-4cc7-ac29-168da6987d2s", text: "Sample Task 11", importance: .low, deadline: Date.tomorrow(), isDone: false, createdAt: Date.now, color: "#FFFFFF")
    var item12 = TodoItemModel(id: "79233728-4ea3-4cc7-ac29-168da6987d2j", text: "Sample Task 12", importance: .low, deadline: Date.now, isDone: false, createdAt: Date.now, color: "#FFFFFF")
    var item13 = TodoItemModel(id: "79233728-4ea3-4cc7-ac29-168da6987d", text: "Sample Task 13", importance: .low, deadline: Date.init(timeIntervalSince1970: 17513979825), isDone: true, createdAt: Date.now, color: "#FFFFFF")
    
    viewModel.addTodoItem(item1)
    viewModel.addTodoItem(item2)
    viewModel.addTodoItem(item3)
    viewModel.addTodoItem(item4)
    viewModel.addTodoItem(item5)
    viewModel.addTodoItem(item6)
    viewModel.addTodoItem(item7)
    viewModel.addTodoItem(item8)
    viewModel.addTodoItem(item9)
    viewModel.addTodoItem(item10)
    viewModel.addTodoItem(item11)
    viewModel.addTodoItem(item12)
    viewModel.addTodoItem(item13)
    
    return TodoListDetails(viewModel: viewModel)
  }
}

#Preview {
  TodoListDetailsAssembly.build()
}
