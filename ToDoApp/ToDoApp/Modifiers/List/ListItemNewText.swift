//
//  ListItemNewText.swift
//  ToDoApp
//

import SwiftUI

struct ListItemNewText: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.system(size: 17))
      .opacity(0.3)
      .frame(height: 22)
  }
}
