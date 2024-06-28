//
//  TodoItemDetailsViewModel.swift
//  ToDoApp
//

import SwiftUI

class TodoItemDetailsViewModel: ObservableObject {
  @Published var item: TodoItemModel
  @Published var data: TodoItemFormData
  
  init(item: TodoItemModel) {
    self.item = item
    self.data = TodoItemFormData(
      text: item.text,
      importance: item.importance,
      deadline: item.deadline
    )
  }

  var hasChanged: Bool {
    var dateChanged = false
    
    if data.isDeadlineEnabled {
      if item.deadline == nil || data.deadline != item.deadline {
        dateChanged = true
      }
    } else {
      if item.deadline != nil {
        dateChanged = true
      }
    }
    
    return item.text != data.text || (
      data.importance != item.importance
    ) || dateChanged
  }
  
  func loadData() {
    data.text = item.text
    data.isDeadlineEnabled = false
    
    if let deadline = item.deadline {
      data.deadline = deadline
      data.isDeadlineEnabled = true
    }
    
    data.importance = item.importance
  }
  
  func saveData() {
    item.text = data.text
    
    if data.isDeadlineEnabled {
      item.deadline = data.deadline
    } else {
      item.deadline = nil
    }
    
    item.importance = data.importance
    
    loadData()
  }
  
  func deleteData() {
    item.text = ""
    item.deadline = nil
    item.importance = .medium
    
    loadData()
  }
}
