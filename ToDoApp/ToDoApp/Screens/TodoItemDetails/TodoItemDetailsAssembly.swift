//
//  TodoItemDetailsAssembly.swift
//  ToDoApp
//

import SwiftUI

enum TodoItemDetailsAssembly {
  static func build(item: TodoItemModel) -> TodoItemDetails {
    let viewModel = TodoItemDetailsViewModel(item: item)
    
    return TodoItemDetails(viewModel: viewModel)
  }
}

#Preview {
  TodoItemDetailsAssembly.build(
    item: TodoItemModel(
      id: "123",
      text: "Some task",
      importance: .low,
      isDone: false
    )
  )
}
