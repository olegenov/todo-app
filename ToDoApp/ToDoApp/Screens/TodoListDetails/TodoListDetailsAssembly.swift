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
    guard let baseUrl = URL(string: "https://hive.mrdekk.ru/todo") else {
      Logger.shared.logError("Base url is incorrect")
      fatalError("Backend url is incorrect")
    }

    let networkingService = DefaultNetworkingService(baseURL: baseUrl)
    let service = TodoItemService(service: networkingService)

    let viewModel = TodoListDetailsViewModel()

    viewModel.service = service
    viewModel.fileCache = FileCache()

    return TodoListDetails(viewModel: viewModel)
  }
}

#Preview {
  TodoListDetailsAssembly.build()
}
