//
//  TodoItemRow.swift
//  ToDoApp
//

import SwiftUI

struct TodoItemRow: View {
  var item: TodoItemModel
  
  var chackmarkImage: some View {
    Image(systemName: !item.isDone ? "circle" : "checkmark.circle.fill")
      .resizable()
      .frame(width: 24, height: 24)
      .foregroundColor(!item.isDone ? Color(red: 0, green: 0, blue: 0, opacity: 0.2) : Color.green)
  }
  
  var rowText: some View {
    Text(item.text)
      .modifier(ListItemText(completed: item.isDone))
  }
  
  var calendarImage: some View {
    Image(systemName: "calendar")
      .resizable()
      .frame(width: 13, height: 12)
      .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.3))
      .frame(width: 16, height: 16)
  }
  
  var buttonForward: some View {
    Button(action: {
      
    }) {
      Image(systemName: "chevron.forward")
        .resizable()
        .frame(width: 6.95, height: 11.9)
        .foregroundColor(Color.gray)
    }
  }
  
  var body: some View {
    HStack {
      HStack(spacing: 16) {
        chackmarkImage
        
        VStack(alignment: .leading, spacing: 1) {
          rowText
          
          if let deadline = item.deadline {
            HStack(spacing: 2) {
              calendarImage
              
              Text(deadline.toString())
                .modifier(ListItemSpecs())
            }
          }
        }
      }
      
      Spacer()
      
      buttonForward
    }
    .padding(.vertical, 8)
  }
}
