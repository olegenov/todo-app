//
//  ListToolBarText.swift
//  ToDoApp
//

import SwiftUI

struct ListToolbarText: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.system(size: 15))
      .frame(height: 20)
      .textCase(nil)
  }
}
