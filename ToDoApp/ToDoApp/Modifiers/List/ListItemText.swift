//
//  ListItemTextStyle.swift
//  ToDoApp
//

import SwiftUI

struct ListItemText: ViewModifier {
  var completed: Bool
  
  func body(content: Content) -> some View {
    content
      .font(.system(size: 17))
      .frame(height: 22)
      .lineLimit(3)
      .opacity(completed ? 0.3 : 1)
      .strikethrough(completed)
  }
}
