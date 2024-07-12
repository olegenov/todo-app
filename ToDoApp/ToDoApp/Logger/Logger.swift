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
    DDLog.add(DDTTYLogger.sharedInstance!)
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
