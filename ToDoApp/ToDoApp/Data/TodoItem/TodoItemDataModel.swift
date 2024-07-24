//
//  TodoItemDataModel.swift
//  ToDoApp
//

import Foundation
import SwiftData

@Model
class TodoItemDataModel: TodoItemData {
  @Attribute(.unique)
  let id: String

  var text: String
  var deadline: Date?

  @Attribute(originalName: "done")
  var isDone: Bool

  @Transient var importance: TodoItem.Importance {
    return TodoItem.Importance(
      rawValue: self.importanceRaw
    ) ?? .medium
  }

  var importanceRaw: String

  @Attribute(originalName: "created_at")
  var createdAt: Date

  @Attribute(originalName: "changed_at")
  var changedAt: Date?

  var color: String?

  init(
    id: String,
    text: String,
    deadline: Date?,
    isDone: Bool,
    importance: TodoItem.Importance,
    createdAt: Date,
    changedAt: Date?,
    color: String?
  ) {
    self.id = id
    self.text = text
    self.deadline = deadline
    self.isDone = isDone
    self.importanceRaw = importance.rawValue
    self.createdAt = createdAt
    self.changedAt = changedAt
    self.color = color
  }

  init(from item: TodoItem) {
    id = item.id
    text = item.text
    importanceRaw = item.importance.rawValue
    deadline = item.deadline
    isDone = item.isDone
    createdAt = item.createdAt
    changedAt = item.changedAt
    color = item.color
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
