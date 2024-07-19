//
//  ErrorModel.swift
//  ToDoApp
//

import Foundation

struct ErrorModel: Identifiable {
  let id: String = UUID().uuidString
  let message: String
}
