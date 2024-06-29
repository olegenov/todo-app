//
//  ToDoItemFormData.swift
//  ToDoApp
//

import SwiftUI

struct TodoItemFormData {
  var text: String = ""
  var importance: TodoItem.Importance = .medium
  var deadline: Date = .tomorrow()
  var isDeadlineEnabled: Bool = false
  var color: Color = .gray
  
  init(text: String, importance: TodoItem.Importance, deadline: Date?, color: String?) {
    self.text = text
    self.importance = importance
    self.deadline = deadline ?? Date.tomorrow()
    self.isDeadlineEnabled = deadline == nil ? false : true
    self.color = Color.getColor(hex: color) ?? Color.clear
  }
  
  init() { }
}
