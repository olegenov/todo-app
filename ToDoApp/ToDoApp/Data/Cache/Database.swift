//
//  Database.swift
//  ToDoApp
//

import SQLite

struct Database {
  enum DatabaseError: Error {
    case invalidPath
  }
  static let shared = Database()
  var database: Connection?

  private init() {
    do {
      guard let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory,
        .userDomainMask,
        true
      ).first else {
        throw DatabaseError.invalidPath
      }

      database = try Connection("\(path)/database.sqlite3")
      initializeTable()
      Logger.shared.logInfo("Database initialized")
    } catch {
      Logger.shared.logError("Failed to connect to the database")
    }
  }

  private func initializeTable() {
    do {
      let todoItems = Table("todo_items")
      let id = Expression<String>("id")
      let text = Expression<String>("text")
      let importance = Expression<String>("importance")
      let deadline = Expression<Date?>("deadline")
      let isDone = Expression<Bool>("is_done")
      let createdAt = Expression<Date>("created_at")
      let changedAt = Expression<Date?>("changed_at")
      let color = Expression<String?>("color")

      try database?.run(todoItems.create(ifNotExists: true) { table in
        table.column(id, primaryKey: true)
        table.column(text)
        table.column(importance)
        table.column(deadline)
        table.column(isDone)
        table.column(createdAt)
        table.column(changedAt)
        table.column(color)
      })
    } catch {
      Logger.shared.logError("Failed to create todo item table")
    }
  }
}
