//
//  Delayer.swift
//  ToDoApp
//

import Foundation

enum Delayer {
  static let minDelay: Double = 1
  static let maxDelay: Double = 2 * 60
  static let factor = 1.5
  static let jitter = 0.0

  static func countDelay(attempt: Int) -> UInt64? {
    let delay = attempt == 1 ? minDelay : minDelay * pow(factor, Double(attempt - 1))

    if delay >= maxDelay {
      return nil
    }

    return UInt64(delay)
  }
}
