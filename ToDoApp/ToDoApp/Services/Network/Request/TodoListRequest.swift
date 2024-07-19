//
//  TodoListRequest.swift
//  ToDoApp
//

import Foundation

struct TodoListRequest: Request {
  let status: String
  let revision: Int
  let list: [TodoItemDto]
}
