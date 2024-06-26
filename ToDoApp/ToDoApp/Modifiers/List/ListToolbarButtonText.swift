//
//  ListToolbarButtonText.swift
//  ToDoApp
//

import SwiftUI

struct ListToolbarButtonText: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.system(size: 15, weight: Font.Weight.bold))
      .frame(height: 20)
      .textCase(nil)
  }
}
