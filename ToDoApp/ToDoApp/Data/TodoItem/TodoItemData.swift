//
//  TodoItemModel.swift
//  ToDoApp
//

import Foundation

protocol TodoItemData: Identifiable {
  var id: String { get }

  var text: String { get }
  var deadline: Date? { get }
  var isDone: Bool { get }
  var importance: TodoItem.Importance { get }
  var createdAt: Date { get }
  var changedAt: Date? { get }
  var color: String? { get }
}
