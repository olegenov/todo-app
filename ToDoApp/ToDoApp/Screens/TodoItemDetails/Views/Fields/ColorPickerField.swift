//
//  ColorPickerField.swift
//  ToDoApp
//

import SwiftUI

struct ColorPickerField: View {
  @State private var isExpanded = false
  @Binding var data: TodoItemFormData

  var body: some View {
    VStack(alignment: .leading) {
      HStack(spacing: 8) {
        Circle()
          .fill(data.color)
          .frame(width: 24, height: 24)
        Text("Цвет задачи")

        Image(systemName: "chevron.down")
          .rotationEffect(.degrees(isExpanded ? 180 : 0))
          .onTapGesture {
            withAnimation {
              isExpanded.toggle()
            }
          }
      }
      .padding(.vertical, 8)
      if isExpanded {
        CustomColorPicker(data: $data.color, width: UIScreen.main.bounds.width - 2 * 32)
      }
    }
  }
}
