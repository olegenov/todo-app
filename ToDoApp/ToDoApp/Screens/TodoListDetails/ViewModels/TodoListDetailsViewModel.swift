//
//  TodoItemsListDetailsViewModel.swift
//  ToDoApp
//

import Foundation

class TodoListDetailsViewModel: ObservableObject {
  @Published var items: [TodoItemModel] = []
  @Published var errorMessage: String?
  
  private let service: TodoItemService
  
  init(service: TodoItemService) {
    self.service = service
  }
  
  func loadTodoItems() {
    guard let itemsList = service.getAllTodoItems() as? [TodoItemModel] else {
      errorMessage = "Failed to add todo item"
      
      return
    }
    
    items = itemsList
  }

  func addTodoItem(_ item: TodoItemModel) {
    do {
//      try service.addTodoItem(item)
    } catch {
      errorMessage = "Failed to add todo item"
    }
    
    loadTodoItems()
  }

  func removeTodoItem(by id: String) {
    service.removeTodoItem(by: id)
    
    loadTodoItems()
  }
  
  func toggleComplited(for item: TodoItemModel) {
    do {
//      let updatedItem = TodoItemModel(
//        id: item.id,
//        text: item.text,
//        importance: item.importance,
//        isDone: !item.isDone
//      )
//      try service.updateTodoItem(updatedItem)
    } catch {
      errorMessage = "Failed to add todo item"
    }
  }
  
  func saveCache() {
    do {
      try service.saveCache()
    } catch {
      errorMessage = "Failed to save cache"
    }
  }
  
  func loadCache() {
    do {
      try service.loadCache()
      loadTodoItems()
    } catch {
      errorMessage = "Failed to load cache"
    }
  }
}
