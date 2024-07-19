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

  var service: TodoItemService?

  var calendarView: CalendarDetailsVCRepresentable?

  func loadTodoItems() async {
    guard let loadedItems = await service?.getList() else {
      await showErrors(messages: ["Ошибка загрузки с сервера"])

      return
    }

    var newList: [TodoItemModel] = []

    for item in loadedItems {
      let itemModel = TodoItemModel(
        id: item.id,
        text: item.text,
        importance: item.importance,
        deadline: item.deadline,
        isDone: item.isDone,
        createdAt: item.createdAt,
        color: item.color,
        category: .empty
      )

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

    Task {
      await sendTodoItemCreationReponse(item)
    }
  }

  @MainActor
  func removeTodoItem(by id: String) {
    items.removeAll { $0.id == id }

    Task {
      await service?.deleteItem(by: id)
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

    let itemObject = TodoItem(
      id: item.id,
      text: item.text,
      importance: item.importance,
      deadline: item.deadline,
      isDone: item.isDone,
      createdAt: item.createdAt,
      changedAt: item.createdAt,
      color: item.color
    )

    Task {
      await service?.putItem(item: itemObject)
    }
  }


  private func sendTodoItemCreationReponse(_ item: TodoItemModel) async {
    let itemObject = TodoItem(
      id: item.id,
      text: item.text,
      importance: item.importance,
      deadline: item.deadline,
      isDone: item.isDone,
      createdAt: item.createdAt,
      changedAt: item.createdAt,
      color: item.color
    )

    _ = await service?.createItem(item: itemObject)
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
}
