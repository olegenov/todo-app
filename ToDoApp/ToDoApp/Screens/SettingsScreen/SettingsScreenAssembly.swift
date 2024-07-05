//
//  SettingsScreenAssembly.swift
//  ToDoApp
//

import SwiftUI

enum SettingsScreenAssembly {
  static func build() -> SettingsView {
    let viewModel = SettingsViewModel()
    
    return SettingsView(viewModel: viewModel)
  }
}

#Preview {
  TodoListDetailsAssembly.build()
}

