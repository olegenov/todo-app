//
//  CustomColorPicker.swift
//  ToDoApp
//

import SwiftUI

struct CustomColorPicker: View {
  @Binding var data: Color
  @State var dragPosition: Double = 16
  @State var brightness: Double = 1.0
  @State var hue: Double = 0.0
  var width: Double

  var hueBackground: some View {
    LinearGradient(
      gradient: Gradient(colors: stride(from: 0.0, to: 1.0, by: 0.01).map {
        Color(hue: $0, saturation: 1.0, brightness: 1.0)
      }),
      startPoint: .leading,
      endPoint: .trailing
    )
    .frame(height: 30)
    .clipShape(.rect(cornerRadius: 16))
  }

  var pickerCircle: some View {
    Circle()
      .fill(Color.white)
      .frame(width: 30, height: 30)
  }

  var body: some View {
    VStack {
      ZStack {
        hueBackground

        pickerCircle
          .position(x: 15 + width * hue, y: 15)
          .gesture(
            DragGesture()
              .onChanged { value in
                if value.location.x >= 15 && value.location.x <= width - 15 {
                  let newValue = (value.location.x - 15) / width
                  hue = min(max(newValue, 0), 1)
                  updateColor()
                }
              }
          )
      }

      Slider(value: Binding<Double>(
        get: { brightness },
        set: { newValue in
          brightness = newValue
          updateColor()
        }
      ), in: 0...1, step: 0.01)
    }
  }

  private func updateColor() {
    data = Color(hue: hue, saturation: 1.0, brightness: brightness)
  }
}
