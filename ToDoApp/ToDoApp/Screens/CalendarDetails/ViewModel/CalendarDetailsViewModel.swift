//
//  CalendarDetailsViewModel.swift
//  ToDoApp
//

import Foundation

class CalendarDetailsViewModel {
  var listViewModel: TodoListDetailsViewModel?
  
  var items: [TodoItemModel] {
    return listViewModel?.items ?? []
  }
  
  func completed(for id: String) {
    guard let item = listViewModel?.items.first(where: { $0.id == id }) else {
      return
    }
    
    listViewModel?.completeItem(for: item)
  }
  
  func uncompleted(for id: String) {
    guard let item = listViewModel?.items.first(where: { $0.id == id }) else {
      return
    }
    
    listViewModel?.uncompleteItem(for: item)
  }
}
