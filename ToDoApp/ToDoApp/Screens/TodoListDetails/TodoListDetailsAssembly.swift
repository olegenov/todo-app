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
    
    viewModel.addTodoItem(TodoItemModel(id: "123", text: "123", importance: .high, isDone: false))
    
    return TodoListDetails(viewModel: viewModel)
  }
}

#Preview {
  TodoListDetailsAssembly.build()
}
