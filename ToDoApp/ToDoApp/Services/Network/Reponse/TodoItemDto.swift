//
//  TodoItemDto.swift
//  ToDoApp
//

import Foundation

struct TodoItemDto: Codable {
  let id: String
  let text: String
  let importance: String
  let deadline: Int?
  let done: Bool
  let createdAt: Int
  let changedAt: Int?
  let color: String?
  let lastUpdatedBy: String?

  enum CodingKeys: String, CodingKey {
    case id
    case text
    case importance
    case deadline
    case done
    case createdAt = "created_at"
    case changedAt = "changed_at"
    case color
    case lastUpdatedBy = "last_updated_by"
  }

  init(from item: TodoItem, updatedBy: String) {
    id = item.id
    text = item.text
    importance = item.importance.rawValue

    if let deadline = item.deadline?.timeIntervalSince1970 {
      self.deadline = Int(deadline)
    } else {
      self.deadline = nil
    }

    done = item.isDone
    createdAt = Int(item.createdAt.timeIntervalSince1970)

    if let changed = item.changedAt?.timeIntervalSince1970 {
      changedAt = Int(changed)
    } else {
      changedAt = Int(Date.now.timeIntervalSince1970)
    }

    color = item.color
    lastUpdatedBy = updatedBy
  }

  func getSource() -> TodoItem {
    var deadline: Date?
    var changedAt: Date?

    if let currentDeadline = self.deadline {
      deadline = Date(timeIntervalSince1970: TimeInterval(currentDeadline))
    }

    if let currentChanged = self.changedAt {
      changedAt = Date(timeIntervalSince1970: TimeInterval(currentChanged))
    }

    return TodoItem(
      id: self.id,
      text: self.text,
      importance: TodoItem.Importance(rawValue: self.importance) ?? .medium,
      deadline: deadline,
      isDone: self.done,
      createdAt: Date(timeIntervalSince1970: TimeInterval(self.createdAt)),
      changedAt: changedAt,
      color: self.color
    )
  }
}
