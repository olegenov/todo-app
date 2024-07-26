//
//  TodoItemModel.swift
//  ToDoApp
//

import Foundation

struct TodoItemModel: TodoItemData {
  let id: String
  var text: String = ""
  var importance: TodoItem.Importance = .medium
  var deadline: Date?
  var isDone: Bool = false
  var createdAt = Date.now
  var changedAt: Date?
  var color: String?
  var category: CategoryModel = .empty

  init(
    id: String,
    text: String = "",
    importance: TodoItem.Importance = .medium,
    deadline: Date? = nil,
    isDone: Bool = false,
    createdAt: Date = Date.now,
    changedAt: Date? = nil,
    color: String? = nil,
    category: CategoryModel = .empty
  ) {
    self.id = id
    self.text = text
    self.importance = importance
    self.deadline = deadline
    self.isDone = isDone
    self.createdAt = createdAt
    self.changedAt = changedAt
    self.color = color
    self.category = category
  }

  init(from item: TodoItem) {
    id = item.id
    text = item.text
    importance = item.importance
    deadline = item.deadline
    isDone = item.isDone
    createdAt = item.createdAt
    changedAt = item.changedAt
    color = item.color
    category = .empty
  }

  func getSource() -> TodoItem {
    return TodoItem(
      id: self.id,
      text: self.text,
      importance: self.importance,
      deadline: self.deadline,
      isDone: self.isDone,
      createdAt: self.createdAt,
      changedAt: self.changedAt,
      color: self.color
    )
  }
}
