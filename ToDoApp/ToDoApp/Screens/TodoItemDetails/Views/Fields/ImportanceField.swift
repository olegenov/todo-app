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
    Text("‼️")
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
        arrowDownIcon
          .tag(TodoItem.Importance.low)
        noImportanceLabel
          .bold()
          .tag(TodoItem.Importance.medium)
        doubleExlamationLabel
          .tag(TodoItem.Importance.high)
      }
      .pickerStyle(.segmented)
      .frame(maxWidth: 150, alignment: .trailing)
    }
  }
}
