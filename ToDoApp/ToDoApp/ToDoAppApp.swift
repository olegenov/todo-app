//
//  ToDoAppApp.swift
//  ToDoApp
//

import SwiftUI
import CocoaLumberjack

@main
struct ToDoAppApp: App {
  init() {
    Logger.shared.logInfo("App started")
  }
  
  var body: some Scene {
    WindowGroup {
      TodoListDetailsAssembly.build()
    }
  }
}
