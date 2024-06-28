//
//  TodoItemModel.swift
//  ToDoApp
//

import Foundation

struct TodoItemModel {
  let id: String
  var text: String
  var importance: TodoItem.Importance
  var deadline: Date?
  var isDone: Bool
}
