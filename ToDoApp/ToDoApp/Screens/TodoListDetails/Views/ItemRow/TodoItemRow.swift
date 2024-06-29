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
      .foregroundColor(!item.isDone ? Color.iconColor : Color.green)
  }
  
  var rowText: some View {
    Text(item.text)
      .font(.system(size: 17))
      .frame(height: 22)
      .opacity(item.isDone ? 0.3 : 1)
      .strikethrough(item.isDone)
  }
  
  var calendarImage: some View {
    Image(systemName: "calendar")
      .resizable()
      .frame(width: 13, height: 12)
      .foregroundColor(Color.iconColor)
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
          if let deadline = item.deadline {
            rowText
              .lineLimit(1)
            
            HStack(spacing: 2) {
              
              calendarImage
              
              Text(deadline.toString())
                .font(.system(size: 15))
                .opacity(0.4)
                .frame(height: 20)
                .lineLimit(1...3)
            }
          } else {
            rowText
              .lineLimit(1...3)
          }
        }
      }
      
      Spacer()
      
      buttonForward
    }
    .padding(.vertical, 8)
  }
}
