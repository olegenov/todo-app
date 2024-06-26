//
//  DateExtension.swift
//  ToDoApp
//

import Foundation

extension Date {
  func toString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMMM"
    dateFormatter.locale = Locale(identifier: "ru_RU")

    let date = Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 17))!

    let formattedDate = dateFormatter.string(from: date)
    
    return formattedDate
  }
}
