//
//  TodoItemResponse.swift
//  ToDoApp
//

import Foundation

struct TodoItemResponse: Codable {
  let status: String
  let revision: Int
  let element: TodoItemDto
}
