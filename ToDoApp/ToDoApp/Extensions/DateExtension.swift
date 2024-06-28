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
  
  static func tomorrow() -> Date {
    let calendar = Calendar.current
    
    return calendar.date(
      byAdding: .day, value: 1, to: Date.now
    ) ?? Date()
  }
}
