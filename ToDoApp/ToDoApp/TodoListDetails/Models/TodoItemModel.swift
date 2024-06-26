//
//  TodoItemModel.swift
//  ToDoApp
//

import Foundation

struct TodoItemModel: Identifiable {
  var id: String
  
  let text: String
  let deadline: Date?
  var isDone: Bool
}
