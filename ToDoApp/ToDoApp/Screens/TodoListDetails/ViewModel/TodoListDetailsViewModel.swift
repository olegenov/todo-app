//
//  TodoItemsListDetailsViewModel.swift
//  ToDoApp
//

import SwiftUI

class TodoListDetailsViewModel: ObservableObject {
  enum Errors: Error {
    case itemDoesNotExist
  }

  @Published var items: [TodoItemModel] = []
  @Published var isModalPresented: Bool = false
  @Published var isSettingsPresented: Bool = false
  @Published var selectedItem: TodoItemModel?
  @Published var errors: [ErrorModel] = []
  @Published var isDirty: Bool = false
  @Published var amountOfRequests = 0

  var service: TodoItemService?
  var fileCache: FileCache?
  var calendarView: CalendarDetailsVCRepresentable?

  func loadTodoItems() async {
    await loadCache()

    guard let loadedItems = await service?.getList() else {
      await showErrors(messages: ["Ошибка загрузки с сервера"])
      await makeDirtyFlag()
      return
    }

    var newList: [TodoItemModel] = []

    for item in loadedItems {
      let itemModel = TodoItemModel(from: item)

      newList.append(itemModel)
    }

    await updateItems(items: newList)
  }

  @MainActor
  func addTodoItem(_ item: TodoItemModel) {
    if items.contains(where: { $0.id == item.id }) {
      Logger.shared.logWarning("Failed to add existing TodoItem with id \(item.id) to list")

      return
    }

    items.append(item)

    let itemObject = item.getSource()

    fileCache?.insert(itemObject)

    Task {
      if isDirty {
        synchronizeData()
      }

      startRequest()
      let item = await service?.createItem(item: itemObject)
      closeRequest()

      if item == nil {
        isDirty = true
      }
    }
  }

  @MainActor
  func removeTodoItem(by id: String) {
    guard let itemToDelete = items.first(where: { $0.id == id }) else {
      Logger.shared.logWarning("Item with id: \(id) does not exist")

      return
    }

    items.removeAll { $0.id == id }
    fileCache?.delete(itemToDelete.getSource())

    Task {
      if isDirty {
        synchronizeData()
      }

      startRequest()

      let item = await service?.deleteItem(by: id)

      closeRequest()

      if item == nil {
        isDirty = true
      }
    }
  }

  @MainActor
  func toggleComplited(for item: TodoItemModel) {
    let updatedItem = TodoItemModel(
      id: item.id,
      text: item.text,
      importance: item.importance,
      deadline: item.deadline,
      isDone: !item.isDone,
      createdAt: item.createdAt,
      changedAt: Date.now,
      color: item.color
    )

    do {
      try updateTodoItem(updatedItem)
    } catch {
      showErrors(messages: ["Задачи не существует"])
    }
  }

  @MainActor
  func completeItem(for item: TodoItemModel) {
    let updatedItem = TodoItemModel(
      id: item.id,
      text: item.text,
      importance: item.importance,
      deadline: item.deadline,
      isDone: true,
      createdAt: item.createdAt,
      changedAt: Date.now,
      color: item.color,
      category: item.category
    )

    do {
      try updateTodoItem(updatedItem)
    } catch {
      showErrors(messages: ["Задачи не существует"])
    }
  }

  @MainActor
  func uncompleteItem(for item: TodoItemModel) {
    let updatedItem = TodoItemModel(
      id: item.id,
      text: item.text,
      importance: item.importance,
      deadline: item.deadline,
      isDone: false,
      createdAt: item.createdAt,
      changedAt: Date.now,
      color: item.color,
      category: item.category
    )

    do {
      try updateTodoItem(updatedItem)
    } catch {
      showErrors(messages: ["Задачи не существует"])
    }
  }

  func openNewItemModal() {
    self.selectedItem = TodoItemModel(id: UUID().uuidString)
    self.isModalPresented = true
  }

  func openEditItemModal(for item: TodoItemModel) {
    self.selectedItem = item
    self.isModalPresented = true
  }

  func closeModal() {
    self.isModalPresented = false
    self.selectedItem = nil
  }

  func deleteItem(at offsets: IndexSet) {
    items.remove(atOffsets: offsets)
  }

  func getModalView(for item: TodoItemModel) -> TodoItemDetails {
    TodoItemDetailsAssembly.build(
      item: item,
      listViewModel: self
    )
  }

  func getSettingsView() -> SettingsView {
    SettingsScreenAssembly.build()
  }

  func getCalendarView() -> CalendarDetailsVCRepresentable? {
    if self.calendarView != nil {
      return calendarView
    }

    let view = CalendarDetailsVCRepresentable(listViewModel: self)

    self.calendarView = view

    return calendarView
  }

  @MainActor
  func updateTodoItem(_ item: TodoItemModel) throws {
    let itemIndex = items.firstIndex {
      $0.id == item.id
    }

    guard let index = itemIndex else {
      throw Errors.itemDoesNotExist
    }

    items[index] = item

    let itemObject = item.getSource()

    try fileCache?.update(itemObject)

    Task {
      if isDirty {
        synchronizeData()
      }

      startRequest()
      let item = await service?.putItem(item: itemObject)
      closeRequest()

      if item == nil {
        isDirty = true
      }
    }
  }

  @MainActor
  private func makeDirtyFlag() {
    isDirty = true
  }

  @MainActor
  private func updateItems(items: [TodoItemModel]) {
    withAnimation {
      self.items = items
    }
  }

  @MainActor
  private func showErrors(messages: [String]) {
    var newErrors: [ErrorModel] = []

    for message in messages {
      newErrors.append(ErrorModel(message: message))
    }

    withAnimation {
      self.errors = newErrors
    }
  }

  @MainActor
  private func synchronizeData() {
    var dataArray: [TodoItem] = []

    for item in items {
      dataArray.append(
        item.getSource()
      )
    }

    Task {
      startRequest()
      let list = await service?.patchList(list: dataArray)
      closeRequest()

      guard let serverList = list else {
        isDirty = true
        return
      }

      isDirty = false

      var updatedList: [TodoItemModel] = []

      for item in serverList {
        updatedList.append(
          TodoItemModel(from: item)
        )
      }

      updateItems(items: updatedList)
    }
  }

  @MainActor
  private func loadCache() {
    guard let cacheItems = try? fileCache?.fetch() else {
      showErrors(messages: ["Не удалось загрузить кэш"])
      return
    }

    var cacheList: [TodoItemModel] = []

    for item in cacheItems {
      cacheList.append(TodoItemModel(from: item))
    }

    items = cacheList
  }

  @MainActor
  private func startRequest() {
    amountOfRequests += 1
  }

  @MainActor
  private func closeRequest() {
    amountOfRequests -= 1
  }
}
