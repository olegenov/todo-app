//
//  CategoryManager.swift
//  ToDoApp
//

import Foundation

class CategoryManager {
  static let shared = CategoryManager()

  var categories: [CategoryModel] = [
    CategoryModel(name: "work", color: "#D04747"),
    CategoryModel(name: "study", color: "#4755D0"),
    CategoryModel(name: "hobby", color: "#5BD047"),
  ]
  
  func addCategory(name: String, color: String) {
    categories.append(CategoryModel(name: name, color: color))
  }
}
