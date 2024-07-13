//
//  TodoItemDetailsAssembly.swift
//  ToDoApp
//

import SwiftUI

enum TodoItemDetailsAssembly {
  static func build(item: TodoItemModel?,
                    listViewModel: TodoListDetailsViewModel) -> TodoItemDetails {
    guard let itemDetails = item else {
      Logger.shared.logWarning("TodoItemDetails view got nil item")

      let viewModel = TodoItemDetailsViewModel(
        item: TodoItemModel(id: UUID().uuidString), listViewModel: listViewModel)

      return TodoItemDetails(viewModel: viewModel)
    }

    let viewModel = TodoItemDetailsViewModel(item: itemDetails, listViewModel: listViewModel)
    return TodoItemDetails(viewModel: viewModel)
  }
}
