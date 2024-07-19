//
//  ErrorView.swift
//  ToDoApp
//

import SwiftUI

struct ErrorView: View {
  var text: String

  var body: some View {
    Text(text)
      .foregroundColor(.white)
      .padding()
      .background(Color.red)
      .cornerRadius(16)
      .frame(maxWidth: .infinity)
      .padding()
  }
}
