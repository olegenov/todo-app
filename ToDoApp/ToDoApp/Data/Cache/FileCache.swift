//
//  FileCache.swift
//  ToDoApp
//

import SwiftUI
import SwiftData

final class FileCache {
  enum FileCacheError: Error {
    case invalidFilename
    case writeFailure
    case loadFailure

    case fetchFailure
    case updateFailure
  }

  private(set) var todoItems: [TodoItem] = []
  private let fileManager = FileManager.default
  private let encoder = JSONEncoder()

  private let modelContainer: ModelContainer?

  init() {
    do {
      modelContainer = try ModelContainer(
        for: TodoItemDataModel.self
      )
    } catch {
      modelContainer = nil
      Logger.shared.logError(
        "Enable to create model container for TodoItem"
      )
    }

    Logger.shared.logInfo("Model container created successfuly")
  }

  @MainActor
  func insert(_ todoItem: TodoItem) {
    let newModel = TodoItemDataModel(from: todoItem)

    modelContainer?.mainContext.insert(newModel)

    saveContext()
  }

  @MainActor
  func fetch() throws -> [TodoItem] {
    let fetchDescriptor = FetchDescriptor<TodoItemDataModel>(
      sortBy: [.init(\.createdAt)]
    )

    guard let fetchItems = try? modelContainer?.mainContext.fetch(
      fetchDescriptor
    ) else {
      Logger.shared.logError(
        "Failed to fetch model container for TodoItem"
      )
      throw FileCacheError.fetchFailure
    }

    var result: [TodoItem] = []

    for item in fetchItems {
      result.append(item.getSource())
    }

    return result
  }

  @MainActor
  func delete(_ todoItem: TodoItem) {
    let model = TodoItemDataModel(from: todoItem)

    modelContainer?.mainContext.delete(model)

    saveContext()
  }

  @MainActor
  func update(_ todoItem: TodoItem) throws {
    let itemId = todoItem.id

    let fetchDescriptor = FetchDescriptor<TodoItemDataModel>(
      predicate: #Predicate { item in
        item.id == itemId
      }
    )

    guard let fetchItems = try? modelContainer?.mainContext.fetch(
      fetchDescriptor
    ) else {
      Logger.shared.logError(
        "Failed to fetch model container for TodoItem"
      )
      throw FileCacheError.fetchFailure
    }

    guard let item = fetchItems.first else {
      Logger.shared.logError(
        "Failed to update model container for TodoItem:" +
        " item with id \(todoItem.id) does not exist"
      )
      throw FileCacheError.updateFailure
    }

    item.text = todoItem.text
    item.deadline = todoItem.deadline
    item.isDone = todoItem.isDone
    item.importanceRaw = todoItem.importance.rawValue
    item.createdAt = todoItem.createdAt
    item.changedAt = todoItem.changedAt
    item.color = todoItem.color

    saveContext()
  }

  @MainActor
  private func saveContext() {
    do {
      try modelContainer?.mainContext.save()
    } catch {
      Logger.shared.logWarning(
        "Failed to save context in TodoItem model container"
      )
    }
  }

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
