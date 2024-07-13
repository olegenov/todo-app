//
//  CategoryModel.swift
//  ToDoApp
//

import Foundation

struct CategoryModel: Identifiable, Hashable {
  static var empty = CategoryModel(name: "", color: "")

  var id: String = UUID().uuidString

  let name: String
  let color: String
}
