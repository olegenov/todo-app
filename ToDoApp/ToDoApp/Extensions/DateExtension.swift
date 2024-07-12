//
//  DateExtension.swift
//  ToDoApp
//

import Foundation

extension Date {
  func toString() -> String {
    let dateFormatter = DateFormatter()
    let calendar = Calendar.current

    dateFormatter.dateFormat = "d MMMM"
    dateFormatter.locale = Locale(identifier: "ru_RU")

    if calendar.component(.year, from: self) != calendar.component(
      .year, from: Date.now
    ) {
      dateFormatter.dateFormat = "d MMMM YYYY"
    }

    let formattedDate = dateFormatter.string(from: self)

    return formattedDate
  }

  func toString(_ components: Set<Calendar.Component>) -> [Calendar.Component: String] {
    let formatter = DateFormatter()

    formatter.locale = Locale(identifier: "ru_RU")

    var result = [Calendar.Component: String]()

    for component in components {
      formatter.dateFormat = ""

      switch component {
      case .day:
        formatter.dateFormat = "d"
      case .month:
        formatter.dateFormat = "MMMM"
      case .year:
        formatter.dateFormat = "YYYY"
      default:
        formatter.dateFormat = nil
      }

      result.updateValue(formatter.string(from: self), forKey: component)
    }

    return result
  }

  func dateOnly() -> Date {
    return Calendar.current.startOfDay(for: self)
  }

  static func tomorrow() -> Date {
    let calendar = Calendar.current

    return calendar.date(
      byAdding: .day, value: 1, to: Date.now
    ) ?? Date()
  }
}
