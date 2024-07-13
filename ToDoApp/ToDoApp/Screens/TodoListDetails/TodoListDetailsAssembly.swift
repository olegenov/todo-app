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

    return TodoListDetails(viewModel: viewModel)
  }
}

#Preview {
  TodoListDetailsAssembly.build()
}
