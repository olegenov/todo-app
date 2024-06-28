//
//  ToDoItemFormData.swift
//  ToDoApp
//

import Foundation

struct TodoItemFormData {
  var text: String = ""
  var importance: TodoItem.Importance = .medium
  var deadline: Date = .tomorrow()
  var isDeadlineEnabled: Bool = false
  
  init(text: String, importance: TodoItem.Importance, deadline: Date?) {
    self.text = text
    self.importance = importance
    self.deadline = deadline ?? Date.tomorrow()
    self.isDeadlineEnabled = deadline == nil ? false : true
  }
  
  init() { }
}
