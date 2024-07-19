//
//  ErrorView.swift
//  ToDoApp
//

import SwiftUI

struct ErrorView: View {
  var text: String
  var closeAction: (() -> Void)?

  var body: some View {
    HStack {
      Text(text)
        .foregroundColor(.white)
        .padding()

      Spacer()

      Button(
        action: {
          closeAction?()
        },
        label: {
          Image(systemName: "xmark")
        }
      )
      .foregroundStyle(.white)
      .padding()
    }
    .background(Color.red)
    .cornerRadius(16)
    .frame(maxWidth: .infinity)
    .padding()
  }
}
