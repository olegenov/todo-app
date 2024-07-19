//
//  ActivityIndicator.swift
//  ToDoApp
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
  @Binding var amountOfRequests: Int

  @MainActor
  func makeUIView(
    context: Context
  ) -> UIActivityIndicatorView {
    let indicator = UIActivityIndicatorView(style: .medium)
    indicator.hidesWhenStopped = true

    return indicator
  }

  @MainActor
  func updateUIView(
    _ uiView: UIActivityIndicatorView,
    context: Context
  ) {
    if amountOfRequests > 0 {
      uiView.startAnimating()
    } else {
      uiView.stopAnimating()
    }
  }
}
