//
//  CustomColorPicker.swift
//  ToDoApp
//

import SwiftUI

struct CustomColorPicker: View {
  @Binding var data: TodoItemFormData
  @State var brightness: Double = 1.0
  @State private var dragLocation: CGPoint = .zero
  
  let gradientColors: [Color] = [
    .red, .yellow, .green, .cyan, .blue, .purple, .pink, .red
  ]
  
  var body: some View {
    VStack {
      ZStack {
        LinearGradient(
          gradient: Gradient(colors: gradientColors),
          startPoint: .leading,
          endPoint: .trailing
        )
        .frame(height: 30)
        .clipShape(.rect(cornerRadius: 16))
        .gesture(
          DragGesture()
            .onChanged { value in
              self.dragLocation = value.startLocation
              self.updateColor(at: value.location)
            }
            .onEnded { value in
              self.updateColor(at: value.location)
            }
        )
      }
      
      Slider(value: Binding<Double>(
        get: { brightness },
        set: { newValue in
          brightness = newValue
          updateColor(at: self.dragLocation)
        }
      ), in: 0...1, step: 0.01)
    }
  }
  
  private func updateColor(at location: CGPoint) {
    let x = max(0, min(location.x, UIScreen.main.bounds.width))
    let percent = x / UIScreen.main.bounds.width
    
    data.color = Color(hue: Double(percent), saturation: 1.0, brightness: brightness)
    dragLocation = location
  }
}
