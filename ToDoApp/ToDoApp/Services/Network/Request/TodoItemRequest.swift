//
//  TodoItemRequest.swift
//  ToDoApp
//

import Foundation

struct TodoItemRequest: Request {
  let status: String
  let revision: Int
  let element: TodoItemDto
}
