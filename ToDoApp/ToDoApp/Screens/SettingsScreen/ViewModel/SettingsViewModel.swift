//
//  SettingsViewModel.swift
//  ToDoApp
//

import SwiftUI

class SettingsViewModel: ObservableObject {
  @Published var data: CategoryFormData
  @ObservedObject var listViewModel: TodoListDetailsViewModel

  init(listVM: TodoListDetailsViewModel) {
    data = CategoryFormData(text: "", color: .gray)
    listViewModel = listVM
  }

  func saveCategory() {
    if data.text.isEmpty {
      return
    }

    CategoryManager.shared.addCategory(name: data.text, color: data.color.toHexString())
  }

  func clear() {
    data = CategoryFormData(text: "", color: .gray)
  }
}
