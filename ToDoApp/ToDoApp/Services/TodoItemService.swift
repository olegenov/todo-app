//
//  TodoItemService.swift
//  ToDoApp
//

import SwiftUI

final class TodoItemService {
  enum TodoItemManagerError: Error {
    case creationFailure
    case cacheLoadingFailure
    case updateFailure
    case cacheSavingFailure
  }
  
  private var cacheFilePath: String = "ToDoApp/cache/data.json"
  
  private let cache: FileCache
  
  init(cache: FileCache) {
    self.cache = cache
    
    do {
      try cache.load(from: cacheFilePath)
    } catch {
      return
    }
  }
  
  func loadCache() throws {
    do {
      try cache.load(from: cacheFilePath)
    } catch {
      throw TodoItemManagerError.cacheLoadingFailure
    }
  }
  
  func addTodoItem(_ item: any TodoItemData) throws {
    guard let newItem = item as? TodoItem else {
      throw TodoItemManagerError.creationFailure
    }
    
    cache.addTodoItem(newItem)
  }
  
  func removeTodoItem(by id: String) {
    cache.removeTodoItem(by: id)
  }
  
  func getAllTodoItems() -> [any TodoItemData] {
    return cache.todoItems
  }
  
  func updateTodoItem(_ item: any TodoItemData) throws {
    guard let updatedItem = item as? TodoItem else {
      throw TodoItemManagerError.creationFailure
    }
    
    cache.removeTodoItem(by: updatedItem.id)
    cache.addTodoItem(updatedItem)
  }
  
  func saveCache() throws {
    do {
      try cache.save(to: cacheFilePath)
    } catch {
      throw TodoItemManagerError.cacheSavingFailure
    }
  }
}
