//
//  ToDoAppApp.swift
//  ToDoApp
//

import SwiftUI

@main
struct ToDoAppApp: App {
  var body: some Scene {
    WindowGroup {
      TodoItemDetailsAssembly.build(item: TodoItemModel(id: "123", text: "Lorem ipsum dolor sit amet", importance: .low, deadline: Date.tomorrow(), isDone: false))
    }
  }
}
