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
      HStack {
        Circle()
          .fill(data.color)
          .frame(width: 24, height: 24)
        Text("Цвет задачи")
          .padding(.leading, 8)
        
        Image(systemName: "chevron.down")
          .rotationEffect(.degrees(isExpanded ? 180 : 0))
          .padding(.leading, 8)
          .onTapGesture {
            withAnimation {
              isExpanded.toggle()
            }
          }
      }
      if isExpanded {
        CustomColorPicker(data: $data)
      }
    }
  }
}
