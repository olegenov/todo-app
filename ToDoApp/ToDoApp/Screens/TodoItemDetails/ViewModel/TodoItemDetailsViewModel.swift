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

    if data.isDeadlineEnabled {
      if item.deadline == nil || data.deadline != item.deadline {
        dateChanged = true
      }
    } else {
      if item.deadline != nil {
        dateChanged = true
      }
    }

    return item.text != data.text || (
      data.importance != item.importance
    ) || dateChanged || (
      data.color.toHexString() != item.color
    ) || (
      data.category.id != item.category.id
    )
  }

  func saveData() {
    item.text = data.text

    if data.isDeadlineEnabled {
      item.deadline = data.deadline
    } else {
      item.deadline = nil
    }

    item.importance = data.importance
    item.color = data.color.toHexString()
    item.category = data.category

    if listViewModel.items.contains(where: { $0.id == item.id }) {
      listViewModel.updateTodoItem(with: item)
    } else {
      listViewModel.addTodoItem(item)
    }
  }

  func deleteData() {
    item.text = ""
    item.deadline = nil
    item.importance = .medium

    listViewModel.removeTodoItem(by: item.id)
    close()
  }

  func close() {
    listViewModel.closeModal()
  }
}
