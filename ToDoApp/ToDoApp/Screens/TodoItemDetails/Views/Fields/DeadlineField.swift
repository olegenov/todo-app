//
//  DeadlineField.swift
//  ToDoApp
//

import SwiftUI

struct DeadlineField: View {
  @Binding var data: TodoItemFormData
  @State var showCalendar: Bool = false
  
  var deadlineToggle: some View {
    Toggle(isOn: $data.isDeadlineEnabled) {
      Text("Сделать до")
      
      if data.isDeadlineEnabled {
        Button(data.deadline.toString()) {
          showCalendar.toggle()
        }
      }
    }
    .onChange(of: data.isDeadlineEnabled) { oldValue, newValue in
      if oldValue {
        showCalendar = false
      }
    }
  }
  
  var deadlinePicker: some View {
    DatePicker("",selection: $data.deadline,
               displayedComponents: .date)
    .datePickerStyle(GraphicalDatePickerStyle())
  }
  
  var body: some View {
    deadlineToggle
    
    if showCalendar {
      Divider()
      deadlinePicker
    }
  }
}
