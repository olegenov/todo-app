//
//  TodoItemRow.swift
//  ToDoApp
//

import SwiftUI

struct TodoItemRow: View {
  var item: TodoItemModel
  var checkMarkAction: (TodoItemModel) -> Void
  var editAction: (TodoItemModel) -> Void

  var chackmarkImage: some View {
    Image(systemName: !item.isDone ? "circle" : "checkmark.circle.fill")
      .resizable()
      .frame(width: 24, height: 24)
      .foregroundColor(!item.isDone ? item.importance == .high ? Color.red : Color.iconColor : Color.green)
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
    Image(systemName: "chevron.forward")
      .resizable()
      .frame(width: 6.95, height: 11.9)
      .foregroundColor(Color.gray)
  }

  var arrowDownIcon: some View {
    Image(systemName: "arrow.down")
      .resizable()
      .frame(width: 11, height: 14)
  }

  var doubleExlamationLabel: some View {
    Text("‼️")
  }

  var body: some View {
    HStack {
      HStack(spacing: 16) {
        chackmarkImage
          .onTapGesture {
            withAnimation {
              checkMarkAction(item)
            }
          }
        HStack(spacing: 4) {
          if item.importance != .medium {
            if item.importance == .low {
              arrowDownIcon
            } else {
              doubleExlamationLabel
            }
          }

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
      }

      Spacer()

      HStack(spacing: 16) {
        if item.category != .empty {
          Circle()
            .fill(Color.getColor(hex: item.category.color) ?? Color.clear)
            .frame(width: 24, height: 24)
        }

        buttonForward
          .onTapGesture {
            editAction(item)
          }
      }
    }
    .padding(.vertical, 8)
    .background(
      RoundedRectangle(cornerRadius: 2)
        .foregroundStyle(Color.getColor(hex: item.color) ?? Color.clear)
        .offset(x: -12)
        .frame(width: 4),
      alignment: .leading
    )
  }
}
