//
//  FileCache.swift
//  ToDoApp
//

import SwiftUI

final class FileCache {
  enum FileCacheError: Error {
    case invalidFilename
    case writeFailure
    case loadFailure
  }

  private(set) var todoItems: [TodoItem] = []
  private let fileManager = FileManager.default
  private let encoder = JSONEncoder()

  func addTodoItem(_ item: TodoItem) {
    if todoItems.contains(where: { $0.id == item.id }) {
      Logger.shared.logWarning(
        "Failed to add existing TodoItem with id \(item.id) to FileCache list"
      )

      return
    }

    todoItems.append(item)
  }

  func removeTodoItem(by id: String) {
    todoItems.removeAll { $0.id == id }
  }

  func save(to filename: String) throws {
    guard let fileURL = applicationDirectory?.appending(
      component: filename
    ) else {
      Logger.shared.logError(
        "Failed to create url for path: \(filename)"
      )

      throw FileCacheError.invalidFilename
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
      Logger.shared.logError(
        "Failed to write data to FileCache file: \(fileURL)"
      )

      throw FileCacheError.writeFailure
    }
  }

  func load(from filename: String) throws {
    guard let fileURL = applicationDirectory?.appending(
      component: filename
    ) else {
      Logger.shared.logError(
        "Failed to create url for path: \(filename)"
      )

      throw FileCacheError.invalidFilename
    }

    do {
      let data = try Data(contentsOf: fileURL)
      let jsonObjects = data.split(separator: 10)

      var loadedItems: [TodoItem] = []

      for jsonObject in jsonObjects {
        if let parsedItem = TodoItem.parse(json: jsonObject) {
          if todoItems.contains(
            where: { $0.id == parsedItem.id }
          ) {
            continue
          }

          loadedItems.append(parsedItem)
        }
      }

      todoItems = loadedItems
    } catch {
      Logger.shared.logError(
        "Failed to read data from FileCache file: \(fileURL)"
      )

      throw FileCacheError.loadFailure
    }
  }

  private var applicationDirectory: URL? {
    return fileManager.urls(
      for: .applicationDirectory,
      in: .userDomainMask
    ).first
  }
}
