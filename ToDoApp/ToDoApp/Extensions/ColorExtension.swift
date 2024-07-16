//
//  ColorExtension.swift
//  ToDoApp
//

import SwiftUI

extension Color {
  static let backgroundColor = Color("BackgroundColor")
  static let listRow = Color("ListRowBackground")
  static let iconColor = Color("IconColor")

  static func getColor(hex: String?) -> Color? {
    guard let hexString = hex else {
      return nil
    }

    var formattedHex = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    if formattedHex.hasPrefix("#") {
      formattedHex.remove(at: formattedHex.startIndex)
    }

    guard formattedHex.count == 6 else {
      return nil
    }

    var rgbValue: UInt64 = 0
    Scanner(string: formattedHex).scanHexInt64(&rgbValue)

    let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
    let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
    let blue = Double(rgbValue & 0x0000FF) / 255.0

    return Color(red: red, green: green, blue: blue)
  }

  func toHexString() -> String {
    guard let components = UIColor(self).cgColor.components else {
      return "#000000"
    }

    let red = components[0]
    let green = components[1]
    let blue = components[2]

    return String(
      format: "#%02lX%02lX%02lX",
      lroundf(Float(red * 255)),
      lroundf(Float(green * 255)),
      lroundf(Float(blue * 255))
    )
  }
}
