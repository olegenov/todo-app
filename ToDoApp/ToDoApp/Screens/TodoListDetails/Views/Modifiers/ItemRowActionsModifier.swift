//
//  ItemRowActionsModifier.swift
//  ToDoApp
//

import SwiftUI

struct ItemRowActionsModifier: ViewModifier {
  let item: TodoItemModel
  let deleteAction: (() -> Void)?
  let editAction: (() -> Void)?
  let toggleAction: (() -> Void)?

  var deleteLabel: some View {
    Label("delete", systemImage: "trash.fill")
      .labelStyle(.iconOnly)
  }

  var infoLabel: some View {
    Label("info", systemImage: "info.circle.fill")
      .labelStyle(.iconOnly)
  }

  var doneLabel: some View {
    Label("done", systemImage: "checkmark.circle.fill")
      .labelStyle(.iconOnly)
  }

  var undoneLabel: some View {
    Label("undone", systemImage: "xmark.circle.fill")
      .labelStyle(.iconOnly)
  }

  func body(content: Content) -> some View {
    content
      .swipeActions(edge: .trailing, allowsFullSwipe: true) {
        Button(role: .destructive) {
          deleteAction?()
        } label: {
          deleteLabel
        }
      }
      .swipeActions(edge: .trailing, allowsFullSwipe: false) {
        Button {
          editAction?()
        } label: {
          infoLabel
        }
        .tint(.gray)
      }
      .swipeActions(edge: .leading, allowsFullSwipe: true) {
        if !item.isDone {
          Button {
            toggleAction?()
          } label: {
            doneLabel
          }
          .tint(.green)
        } else {
          Button {
            toggleAction?()
          } label: {
            undoneLabel
          }
          .tint(.gray)
        }
      }
  }
}
