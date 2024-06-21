//
//  FileCache.swift
//  ToDoApp
//
//  Created by Никита Китаев on 20.06.2024.
//

import Foundation

class FileCache {
  private(set) var todoItems: [TodoItem] = []
  private let fileManager = FileManager.default
  private let encoder = JSONEncoder()
  
  func addTodoItem(_ item: TodoItem) {
    if todoItems.contains(where: { $0.id == item.id }) {
      return
    }
    
    todoItems.append(item)
  }
  
  func removeTodoItem(by id: String) {
    todoItems.removeAll { $0.id == id }
  }
  
  func save(to filename: String) throws {
    guard let fileURL = getDocumentsDirectory()?.appending(component: filename) else {
      throw NSError(domain: "InvalidFilename", code: 0)
    }
    
    var dataArray = Data()
    
    for item in todoItems {
      if let data = item.json as? Data {
        dataArray.append(data)
        dataArray.append(10)
      }
    }
    
    do {
      try dataArray.write(to: fileURL)
    } catch {
      throw NSError(domain: "WriteFailure", code: 0)
    }
  }
  
  func load(from filename: String) throws {
    guard let fileURL = getDocumentsDirectory()?.appending(component: filename) else {
      return
    }
    
    do {
      let data = try Data(contentsOf: fileURL)
      let jsonObjects = data.split(separator: 10)
      
      var loadedItems = [TodoItem]()
      
      for jsonObject in jsonObjects {
        if let parsedItem = TodoItem.parse(json: jsonObject) {
          if todoItems.contains(where: { $0.id == parsedItem.id }) {
            continue
          }
          
          loadedItems.append(parsedItem)
        }
      }
      
      todoItems = loadedItems
      
    } catch {
      throw NSError(domain: "loadingFailure", code: 0)
    }
  }
  
  private func getDocumentsDirectory() -> URL? {
    return fileManager.urls(for: .applicationDirectory, in: .userDomainMask).first
  }
}
