//
//  AdaptiveView.swift
//  ToDoApp
//
import SwiftUI

struct AdaptiveView<Content: View>: View {
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass
  
  var content: Content
  var spacing: CGFloat
  
  public init(spacing: CGFloat, @ViewBuilder content: () -> Content) {
    self.content = content()
    self.spacing = spacing
  }

  var body: some View {
    if horizontalSizeClass == .regular {
      VStack(spacing: spacing) {
        content
      }
    } else if verticalSizeClass == .compact {
      HStack(spacing: spacing) {
        content
      }
    }
  }
}
