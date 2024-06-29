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
  var createdAt: Date = Date.now
  var color: String?
}
