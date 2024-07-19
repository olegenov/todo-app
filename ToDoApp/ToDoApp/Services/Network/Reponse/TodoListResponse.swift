//
//  TodoListResponse.swift
//  ToDoApp
//

import Foundation

struct TodoListResponse: Codable {
  let status: String
  let revision: Int
  let list: [TodoItemDto]
}
