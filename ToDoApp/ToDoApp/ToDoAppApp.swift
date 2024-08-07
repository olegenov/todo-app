//
//  ToDoAppApp.swift
//  ToDoApp
//

import SwiftUI
import CocoaLumberjack

@main
struct ToDoAppApp: App {
  init() {
    _ = TokenManager.shared.save(token: "Elured")
    Logger.shared.logInfo("App started")
  }

  var body: some Scene {
    WindowGroup {
      TodoListDetailsAssembly.build()
    }
  }
}
