//
//  ImportanceField.swift
//  ToDoApp
//

import SwiftUI

struct ImportanceField: View {
  @Binding var data: TodoItemFormData
  
  var arrowDownIcon: some View {
    Image(systemName: "arrow.down")
      .resizable()
      .frame(width: 11, height: 14)
  }
  
  var doubleExlamationLabel: some View {
    Text("!!")
      .foregroundStyle(Color.red)
  }
  
  var noImportanceLabel: Text {
    Text("нет")
      .bold()
  }
  
  var body: some View {
    HStack {
      Text("Важность")
      
      Spacer()
      
      Picker("Важность", selection: $data.importance) {
        arrowDownIcon.tag(TodoItem.Importance.low)
          .foregroundStyle(Color.red)
        Text("нет")
          .bold()
          .tag(TodoItem.Importance.medium)
          .foregroundStyle(Color.red)
        doubleExlamationLabel.tag(TodoItem.Importance.high)
          .foregroundStyle(Color.red)
      }
      .pickerStyle(.palette)
      .frame(maxWidth: 150, alignment: .trailing)
    }
  }
}
