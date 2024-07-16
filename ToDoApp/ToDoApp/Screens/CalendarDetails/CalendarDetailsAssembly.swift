//
//  CalendarDetailsAssembly.swift
//  ToDoApp
//

import Foundation
import CocoaLumberjack

enum CalendarDetailsAssembly {
  @MainActor
  static func build(
    listViewModel: TodoListDetailsViewModel
  ) -> CalendarDetailsViewController {
    let viewController = CalendarDetailsViewController()
    let viewModel = CalendarDetailsViewModel()
    viewModel.listViewModel = listViewModel

    viewController.viewModel = viewModel

    return viewController
  }
}
