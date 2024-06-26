//
//  TodoListDetails.swift
//  ToDoApp
//

import SwiftUI

struct TodoListDetails: View {
  @StateObject private var todoItemsList = TodoItemsList()
  @State private var showCompleted: Bool = false

  var addNewCell: some View {
    Text("Новое")
      .modifier(ListItemNewText())
      .padding([.leading], 40)
      .padding(.vertical, 8)
  }
  
  var completedTasksCount: Int {
    todoItemsList.items.filter { $0.isDone }.count
  }
  
  var completeCounter: some View {
    Text("Выполнено — \(completedTasksCount)")
      .modifier(ListToolbarText())
  }
  
  var openButton: some View {
    Button {
      showCompleted.toggle()
    } label: {
      Text(showCompleted ? "Скрыть" : "Показать")
        .modifier(ListToolbarButtonText())
    }
  }
  
  var todoList: some View {
    List {
      Section {
        ForEach(todoItemsList.items) { item in
          if !item.isDone || showCompleted {
            TodoItemRow(item: item)
              .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
          }
        }
        
        addNewCell
          .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
      } header: {
        HStack {
          completeCounter
            .padding([.leading], -5)
          Spacer()
            .padding([.leading], 5)
          openButton
        }
        .padding(.bottom, 12)
      }
    }
    .listStyle(.insetGrouped)
    .cornerRadius(16)
    .scrollClipDisabled(false)
    .scrollContentBackground(.hidden)
  }
  
  var body: some View {
    NavigationStack {
      ZStack {
        todoList
          .padding(.horizontal, -16)
          .navigationTitle("Мои дела")
      }
      .background(Color(red: 247/255, green: 246/255, blue: 242/255))
    }
    .padding(.horizontal, 16)
    .background(Color(red: 247/255, green: 246/255, blue: 242/255))
  }
  
  private func toggleComplited(for item: TodoItemModel) {
    todoItemsList.toggleComplited(for: item)
  }
}

#Preview {
  TodoListDetails()
}
