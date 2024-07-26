//
//  TodoItemService.swift
//  ToDoApp
//

import SwiftUI

final class TodoItemService {
  enum TodoItemManagerError: Error {
    case cacheLoadingFailure
    case updateFailure
    case cacheSavingFailure
  }

  private let networkingService: NetworkingService
  private var currentRevision: Int = 0

  init(service: NetworkingService) {
    self.networkingService = service
  }

  func getList() async -> [TodoItem]? {
    var todoList: [TodoItem] = []
    var revision: Int = 0
    var error: Bool = false

    await networkingService.get(
      path: "/list"
    ) { (result: Result<TodoListResponse, Error>) in
      switch result {
      case .success(let response):
        revision = response.revision

        for item in response.list {
          let parsedItem = item.getSource()

          todoList.append(parsedItem)
        }
      case .failure:
        Logger.shared.logError("Error loading TodoItem list")

        error = true
      }
    }

    await setCurrentRevision(revision: revision)

    if error {
      return nil
    }

    Logger.shared.logInfo("List loaded successfully")

    return todoList
  }

  func createItem(item: TodoItem) async -> TodoItem? {
    var revision: Int = 0
    var parsedItem: TodoItem?

    let itemDto = TodoItemDto(
      from: item,
      updatedBy: "0d0970774e284fa8ba9ff70b6b06479a"
    )

    let request = TodoItemRequest(
      status: "ok",
      revision: currentRevision,
      element: itemDto
    )

    await networkingService.post(
      path: "/list",
      requestObject: request
    ) { (result: Result<TodoItemResponse, Error>) in
      switch result {
      case .success(let response):
        revision = response.revision

        let item = response.element

        parsedItem = item.getSource()
      case .failure:
        Logger.shared.logError("Error creating TodoItem in network")
      }
    }

    await setCurrentRevision(revision: revision)

    Logger.shared.logInfo("Item created successfully")

    return parsedItem
  }

  func deleteItem(by id: String) async -> TodoItem? {
    var revision: Int = 0
    var parsedItem: TodoItem?

    let request = TodoItemDeletionRequest(
      revision: currentRevision
    )

    await networkingService.delete(
      path: "/list/\(id)",
      requestObject: request
    ) { (result: Result<TodoItemResponse, Error>) in
      switch result {
      case .success(let response):
        revision = response.revision

        let item = response.element

        parsedItem = item.getSource()
      case .failure:
        Logger.shared.logError("Error deleting TodoItem")
      }
    }

    await setCurrentRevision(revision: revision)

    Logger.shared.logInfo("Item deleted successfully")

    return parsedItem
  }

  func putItem(item: TodoItem) async -> TodoItem? {
    var revision: Int = 0
    var parsedItem: TodoItem?

    let itemDto = TodoItemDto(
      from: item,
      updatedBy: "0d0970774e284fa8ba9ff70b6b06479a"
    )

    let request = TodoItemRequest(
      status: "ok",
      revision: currentRevision,
      element: itemDto
    )

    await networkingService.put(
      path: "/list/\(item.id)",
      requestObject: request
    ) { (result: Result<TodoItemResponse, Error>) in
      switch result {
      case .success(let response):
        revision = response.revision

        let item = response.element

        parsedItem = item.getSource()
      case .failure:
        Logger.shared.logError("Error putting TodoItem")
      }
    }

    await setCurrentRevision(revision: revision)

    Logger.shared.logInfo("Item put successfully")

    return parsedItem
  }

  func getItem(for id: String) async -> TodoItem? {
    var todoItem: TodoItem?
    var revision: Int = 0
    var error: Bool = false

    await networkingService.get(
      path: "/list/\(id)"
    ) { (result: Result<TodoItemResponse, Error>) in
      switch result {
      case .success(let response):
        revision = response.revision

        todoItem = response.element.getSource()
      case .failure:
        Logger.shared.logError("Error loading TodoItem")

        error = true
      }
    }

    await setCurrentRevision(revision: revision)

    if error {
      return nil
    }

    Logger.shared.logInfo("TodoItem loaded successfully")

    return todoItem
  }

  func patchList(list: [TodoItem]) async -> [TodoItem]? {
    var todoList: [TodoItem] = []
    var revision: Int = 0
    var error: Bool = false

    var todoItemDtos: [TodoItemDto] = []

    for item in list {
      todoItemDtos.append(
        TodoItemDto(
          from: item,
          updatedBy: "0d0970774e284fa8ba9ff70b6b06479a"
        )
      )
    }

    let request = TodoListRequest(
      status: "ok",
      revision: currentRevision,
      list: todoItemDtos
    )

    await networkingService.patch(
      path: "/list",
      requestObject: request
    ) { (result: Result<TodoListResponse, Error>) in
      switch result {
      case .success(let response):
        revision = response.revision

        for item in response.list {
          let parsedItem = item.getSource()

          todoList.append(parsedItem)
        }
      case .failure:
        Logger.shared.logError("Error loading TodoItem list")

        error = true
      }
    }

    await setCurrentRevision(revision: revision)

    if error {
      return nil
    }

    Logger.shared.logInfo("List loaded successfully")

    return todoList
  }

  @MainActor
  private func setCurrentRevision(revision: Int) {
    if revision != 0 {
      currentRevision = revision
    }
  }
}
