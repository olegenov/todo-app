//
//  TodoListDetails.swift
//  ToDoApp
//

import SwiftUI

struct TodoListDetails: View {
  @ObservedObject var viewModel: TodoListDetailsViewModel
  @State private var showCompleted: Bool = false
  
  var addNewCell: some View {
    Text("Новое")
      .modifier(ListItemNewText())
      .padding([.leading], 40)
      .padding(.vertical, 8)
  }
  
  var completedTasksCount: Int {
    viewModel.items.filter { $0.isDone }.count
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
  
  var addButton: some View {
    Button(action: {
      
    }) {
      ZStack {
        Image(systemName: "circle.fill")
          .renderingMode(.template)
          .resizable()
          .frame(width: 44, height: 44)
          .foregroundColor(Color.white)
        
        Image(systemName: "plus.circle.fill")
          .renderingMode(.template)
          .resizable()
          .frame(width: 44, height: 44)
          .foregroundColor(Color.blue)
      }
      .shadow(color: Color(UIColor(red: 0/255, green: 73/255, blue: 153/255, alpha: 0.3)), radius: 20, x: 0, y: 8)
    }
  }
  
  var todoList: some View {
    List {
      Section {
//        ForEach(viewModel.items) { item in
//          if !item.isDone || showCompleted {
//            TodoItemRow(item: item)
//              .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
//              .listRowBackground(Color.listRowBackground)
//          }
//        }
        
        addNewCell
          .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
          .listRowBackground(Color.listRowBackground)
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
      .background(Color.backgroundColor)
      
      .toolbar {
        ToolbarItem(placement: .bottomBar) {
          addButton
        }
      }
    }
    .padding(.horizontal, 16)
    .background(Color.backgroundColor)
    .onDisappear {
      viewModel.saveCache()
    }
  }
  
  private func toggleComplited(for item: TodoItemModel) {
    viewModel.toggleComplited(for: item)
  }
}
