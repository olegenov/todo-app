//
//  Logger.swift
//  ToDoApp
//

import Foundation
import CocoaLumberjackSwift

class Logger {
  static let shared = Logger()

  private init() {
    congifureLogger()
  }

  private func congifureLogger() {
    guard let logger = DDTTYLogger.sharedInstance else {
      return
    }

    DDLog.add(logger)
  }

  func logInfo(_ message: String) {
    DDLogInfo(message)
  }

  func logWarning(_ message: String) {
    DDLogWarn(message)
  }

  func logError(_ message: String) {
    DDLogError(message)
  }
}
