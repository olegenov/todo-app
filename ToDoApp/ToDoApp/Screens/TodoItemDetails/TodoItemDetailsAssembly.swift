//
//  TodoItemDetailsAssembly.swift
//  ToDoApp
//

import SwiftUI

enum TodoItemDetailsAssembly {
  static func build(item: TodoItemModel?,
                    presentedAsModal: Binding<Bool>,
                    listViewModel: TodoListDetailsViewModel) -> TodoItemDetails {
    
    guard let itemDetails = item else {
      let viewModel = TodoItemDetailsViewModel(
        item: TodoItemModel(id: UUID().uuidString), listViewModel: listViewModel)
      
      return TodoItemDetails(viewModel: viewModel)
    }
    
    let viewModel = TodoItemDetailsViewModel(item: itemDetails, listViewModel: listViewModel)
    return TodoItemDetails(viewModel: viewModel)
  }
}
