//
//  SettingsViewModel.swift
//  ToDoApp
//

import Foundation

class SettingsViewModel: ObservableObject {
  @Published var data: CategoryFormData
  
  init() {
    data = CategoryFormData(text: "", color: .gray)
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
