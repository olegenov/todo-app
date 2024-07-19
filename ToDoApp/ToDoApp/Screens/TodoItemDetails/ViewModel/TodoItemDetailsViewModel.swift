//
//  TodoItemDetailsViewModel.swift
//  ToDoApp
//

import SwiftUI

class TodoItemDetailsViewModel: ObservableObject {
  @Published var item: TodoItemModel
  @Published var data: TodoItemFormData

  private let listViewModel: TodoListDetailsViewModel

  init(item: TodoItemModel, listViewModel: TodoListDetailsViewModel) {
    self.item = item
    self.data = TodoItemFormData(
      text: item.text,
      importance: item.importance,
      deadline: item.deadline,
      color: item.color,
      category: item.category
    )
    self.listViewModel = listViewModel
  }

  var hasChanged: Bool {
    var dateChanged = false
    var colorChanged = false

    if data.isDeadlineEnabled {
      if item.deadline == nil || data.deadline != item.deadline {
        dateChanged = true
      }
    } else {
      if item.deadline != nil {
        dateChanged = true
      }
    }

    if data.isColorEnabled {
      if item.color == nil || data.color.toHexString() != item.color {
        colorChanged = true
      }
    } else {
      if item.color != nil {
        colorChanged = true
      }
    }

    return item.text != data.text || (
      data.importance != item.importance
    ) || dateChanged || (
      colorChanged
    ) || (
      data.category.id != item.category.id
    )
  }

  @MainActor
  func saveData() {
    item.text = data.text

    if data.isDeadlineEnabled {
      item.deadline = data.deadline
    } else {
      item.deadline = nil
    }

    item.importance = data.importance

    if data.isColorEnabled {
      item.color = data.color.toHexString()
    } else {
      item.color = nil
    }

    item.category = data.category

    Task {
      if listViewModel.items.contains(where: { $0.id == item.id }) {
        do {
          try listViewModel.updateTodoItem(item)
        } catch {
        }
      } else {
        listViewModel.addTodoItem(item)
      }
    }
  }

  @MainActor
  func deleteData() {
    item.text = ""
    item.deadline = nil
    item.importance = .medium

    Task {
      listViewModel.removeTodoItem(by: item.id)
    }

    close()
  }

  func close() {
    listViewModel.closeModal()
  }
}
