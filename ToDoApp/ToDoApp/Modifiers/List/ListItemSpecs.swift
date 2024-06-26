//
//  ListItemSpecs.swift
//  ToDoApp
//
//  Created by Никита Китаев on 26.06.2024.
//

import SwiftUI

struct ListItemSpecs: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.system(size: 15))
      .opacity(0.3)
      .frame(height: 20)
  }
}
