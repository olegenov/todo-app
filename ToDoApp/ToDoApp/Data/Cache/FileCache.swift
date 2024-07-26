//
//  FileCache.swift
//  ToDoApp
//

import SwiftUI
import SwiftData
import SQLite

final class FileCache {
  enum FileCacheError: Error {
    case invalidFilename
    case writeFailure
    case loadFailure

    case fetchFailure
    case updateFailure
  }

  enum SortingFields {
    case id
    case createdAt
    case deadline
  }

  enum SortingTypes {
    case ascending
    case descending
  }

  struct SortingType {
    let field: SortingFields
    let type: SortingTypes
  }

  enum FilteringType {
    case isDone(Bool)
    case deadline(Date)
    case importance(TodoItem.Importance.RawValue)
  }

  enum StorageType: String {
    case swiftData = "swift_data"
    case sqlite = "sqlite"
  }

  private(set) var todoItems: [TodoItem] = []
  private let fileManager = FileManager.default
  private let encoder = JSONEncoder()

  private let modelContainer: ModelContainer?
  private var currentStorageType: StorageType = .swiftData

  private var applicationDirectory: URL? {
    return fileManager.urls(
      for: .applicationDirectory,
      in: .userDomainMask
    ).first
  }

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

    Logger.shared.logInfo("Filecache: Model container created successfuly")
  }


  @MainActor
  func insert(_ todoItem: TodoItem) {
    loadSettings()

    if currentStorageType == .sqlite {
      insertByDB(todoItem)

      return
    }

    insertBySwiftData(todoItem)
  }

  @MainActor
  func fetch() throws -> [TodoItem] {
    loadSettings()

    if currentStorageType == .sqlite {
      return fetchByDB()
    }

    return try fetchBySwiftData()
  }

  @MainActor
  func delete(_ todoItem: TodoItem) {
    loadSettings()

    if currentStorageType == .sqlite {
      deleteByDB(todoItem)
    }

    return deleteBySwiftData(todoItem)
  }

  @MainActor
  func update(_ todoItem: TodoItem) throws {
    loadSettings()

    if currentStorageType == .sqlite {
      return updateByDB(todoItem)
    }

    return try updateBySwiftData(todoItem)
  }

  @MainActor
  func insertBySwiftData(_ todoItem: TodoItem) {
    let newModel = TodoItemDataModel(from: todoItem)

    modelContainer?.mainContext.insert(newModel)

    saveContext()
  }

  @MainActor
  func fetchBySwiftData() throws -> [TodoItem] {
    let fetchDescriptor = FetchDescriptor<TodoItemDataModel>(
      sortBy: [.init(\.createdAt)]
    )

    let result = try doFetch(descriptor: fetchDescriptor)

    return result
  }

  @MainActor
  func fetchBySwiftData(
    sorting: SortingType,
    filtering: FilteringType
  ) throws -> [TodoItem] {
    let sortDescriptor = getSortDescriptor(from: sorting)
    let predicate = getPredicate(from: filtering)

    let fetchDescriptor = FetchDescriptor<TodoItemDataModel>(
      predicate: predicate,
      sortBy: [sortDescriptor]
    )

    let result = try doFetch(descriptor: fetchDescriptor)

    return result
  }

  @MainActor
  private func doFetch(
    descriptor: FetchDescriptor<TodoItemDataModel>
  ) throws -> [TodoItem] {
    guard let fetchItems = try? modelContainer?.mainContext.fetch(
      descriptor
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

    Logger.shared.logInfo("Filecache: Items fetched successfuly")

    return result
  }

  @MainActor
  func deleteBySwiftData(_ todoItem: TodoItem) {
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

      return
    }

    guard let item = fetchItems.first else {
      Logger.shared.logError(
        "Failed to delete model container for TodoItem:" +
        " item with id \(todoItem.id) does not exist"
      )

      return
    }

    modelContainer?.mainContext.delete(item)

    Logger.shared.logInfo("Filecache: Item deleted successfuly")

    saveContext()
  }

  @MainActor
  func updateBySwiftData(_ todoItem: TodoItem) throws {
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

    Logger.shared.logInfo("Filecache: Item updated successfuly")

    saveContext()
  }

  func insertByDB(_ todoItem: TodoItem) {
    do {
      let table = Table("todo_items")
      let id = Expression<String>("id")
      let text = Expression<String>("text")
      let importance = Expression<String>("importance")
      let deadline = Expression<Date?>("deadline")
      let isDone = Expression<Bool>("is_done")
      let createdAt = Expression<Date>("created_at")
      let changedAt = Expression<Date?>("changed_at")
      let color = Expression<String?>("color")

      let insert = table.insert(
        id <- todoItem.id,
        text <- todoItem.text,
        importance <- todoItem.importance.rawValue,
        deadline <- todoItem.deadline,
        isDone <- todoItem.isDone,
        createdAt <- todoItem.createdAt,
        changedAt <- todoItem.changedAt,
        color <- todoItem.color
      )
      try Database.shared.database?.run(insert)
    } catch {
      Logger.shared.logError("Failure in database insert")
    }
  }

  func fetchByDB() -> [TodoItem] {
    var result: [TodoItem] = []

    do {
      let table = Table("todo_items")
      let id = Expression<String>("id")
      let text = Expression<String>("text")
      let importance = Expression<String>("importance")
      let deadline = Expression<Date?>("deadline")
      let isDone = Expression<Bool>("is_done")
      let createdAt = Expression<Date>("created_at")
      let changedAt = Expression<Date?>("changed_at")
      let color = Expression<String?>("color")

      guard let preparedTable = try? Database.shared.database?.prepare(
        table
      ) else {
        throw FileCacheError.fetchFailure
      }

      for item in preparedTable {
        let importanceValue = TodoItem.Importance(
          rawValue: item[importance]
        ) ?? .medium

        let todoItem = TodoItem(
          id: item[id],
          text: item[text],
          importance: importanceValue,
          deadline: item[deadline],
          isDone: item[isDone],
          createdAt: item[createdAt],
          changedAt: item[changedAt],
          color: item[color]
        )
        result.append(todoItem)
      }
    } catch {
      Logger.shared.logError("Failure in database fetch")
    }

    return result
  }

  func deleteByDB(_ todoItem: TodoItem) {
    do {
      let table = Table("todo_items")
      let id = Expression<String>("id")
      let item = table.filter(id == todoItem.id)
      try Database.shared.database?.run(item.delete())
    } catch {
      Logger.shared.logError("Failure in database delete")
    }
  }

  func updateByDB(_ todoItem: TodoItem) {
    do {
      let table = Table("todo_items")
      let id = Expression<String>("id")
      let text = Expression<String>("text")
      let importance = Expression<String>("importance")
      let deadline = Expression<Date?>("deadline")
      let isDone = Expression<Bool>("is_done")
      let changedAt = Expression<Date?>("changed_at")
      let color = Expression<String?>("color")

      let item = table.filter(id == todoItem.id)

      let update = item.update([
        text <- todoItem.text,
        importance <- todoItem.importance.rawValue,
        deadline <- todoItem.deadline,
        isDone <- todoItem.isDone,
        changedAt <- todoItem.changedAt,
        color <- todoItem.color
      ])
      try Database.shared.database?.run(update)
    } catch {
      Logger.shared.logError("Failure in database update")
    }
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

  private func getSortDescriptor(
    from type: SortingType
  ) -> SortDescriptor<TodoItemDataModel> {
    var order: SortOrder

    switch type.type {
    case .ascending:
      order = .forward
    case .descending:
      order = .reverse
    }

    switch type.field {
    case .id:
      return SortDescriptor<TodoItemDataModel>(
        \.id, order: order
      )
    case .createdAt:
      return SortDescriptor<TodoItemDataModel>(
        \.createdAt, order: order
      )
    case .deadline:
      return SortDescriptor<TodoItemDataModel>(
        \.deadline, order: order
      )
    }
  }

  private func getPredicate(
    from filtering: FilteringType
  ) -> Predicate<TodoItemDataModel> {
    switch filtering {
    case .isDone(let done):
      return #Predicate { $0.isDone == done }
    case .deadline(let date):
      return #Predicate { item in
        if let deadline = item.deadline {
          return deadline == date
        } else {
          return false
        }
      }
    case .importance(let importance):
      return #Predicate { $0.importance.rawValue == importance }
    }
  }

  private func loadSettings() {
    if let value = UserDefaults.standard.string(forKey: "data_storage") {
      currentStorageType = StorageType(rawValue: value) ?? .swiftData
    } else {
      currentStorageType = .swiftData
    }
  }
}
