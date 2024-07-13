//
//  UIColorExtension.swift
//  ToDoApp
//

import UIKit

extension UIColor {
  static let backgroundColor = UIColor(named: "BackgroundColor")
  static let listRow = UIColor(named: "ListRowBackground")
  static let iconColor = UIColor(named: "IconColor")
  static let textColor = UIColor(named: "TextColor")

  static func getColor(hex: String?) -> UIColor? {
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

    return UIColor(red: red, green: green, blue: blue, alpha: 1)
  }
}
