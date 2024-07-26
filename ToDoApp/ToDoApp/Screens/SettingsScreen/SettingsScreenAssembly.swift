//
//  SettingsScreenAssembly.swift
//  ToDoApp
//

import SwiftUI

enum SettingsScreenAssembly {
  @MainActor
  static func build(
    listVM: TodoListDetailsViewModel
  ) -> SettingsView {
    let viewModel = SettingsViewModel(listVM: listVM)

    return SettingsView(
      viewModel: viewModel
    )
  }
}

#Preview {
  TodoListDetailsAssembly.build()
}
