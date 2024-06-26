//
//  TodoListDetails.swift
//  ToDoApp
//

import SwiftUI

struct TodoListDetails: View {
  @ObservedObject var viewModel: TodoListDetailsViewModel
  @State private var showCompleted: Bool = false
  @State var presentingModal = false
  
  var addNewCell: some View {
    Text("Новое")
      .opacity(0.3)
      .padding([.leading], 40)
      .padding(.vertical, 8)
  }
  
  var completedTasksCount: Int {
    viewModel.items.filter { $0.isDone }.count
  }
  
  var completeCounter: some View {
    Text("Выполнено — \(completedTasksCount)")
      .font(.system(size: 15))
      .frame(height: 20)
      .textCase(nil)
  }
  
  var openButton: some View {
    Button {
      withAnimation {
        showCompleted.toggle()
      }
    } label: {
      Text(showCompleted ? "Скрыть" : "Показать")
        .textCase(nil)
        .font(.system(size: 15, weight: Font.Weight.bold))
    }
  }
  
  var addButton: some View {
    Button(action: {
      viewModel.openNewItemModal()
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
  
  var todoList: some View {
    List {
      Section {
        ForEach(viewModel.items) { item in
          if !item.isDone || showCompleted {
            TodoItemRow(item: item)
              .listRowBackground(Color.listRowBackground)
              .background(Color.getColor(hex: item.color)
                .offset(x: -16)
                .edgesIgnoringSafeArea(.vertical)
                .frame(width: 2), alignment: .leading
              )
              .onTapGesture {
                viewModel.openEditItemModal(for: item)
              }
              .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                  viewModel.removeTodoItem(by: item.id)
                } label: {
                  deleteLabel
                }
              }
              .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button {
                  viewModel.openEditItemModal(for: item)
                } label: {
                  infoLabel
                }
                .tint(.gray)
              }
              .swipeActions(edge: .leading, allowsFullSwipe: true) {
                if !item.isDone {
                  Button {
                    toggleComplited(for: item)
                  } label: {
                    doneLabel
                  }
                  .tint(.green)
                } else {
                  Button {
                    toggleComplited(for: item)
                  } label: {
                    undoneLabel
                  }
                  .tint(.gray)
                }
              }
          }
        }
        
        addNewCell
          .listRowBackground(Color.listRowBackground)
          .onTapGesture {
            viewModel.openNewItemModal()
          }
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
    .sheet(isPresented: $viewModel.isModalPresented) {
      if let item = viewModel.selectedItem {
        getModalView(for: item)
      }
    }
  }
  
  private func toggleComplited(for item: TodoItemModel) {
    viewModel.toggleComplited(for: item)
  }
  
  func getModalView(for item: TodoItemModel) -> TodoItemDetails {
    TodoItemDetailsAssembly.build(
      item: item,
      presentedAsModal: self.$presentingModal,
      listViewModel: self.viewModel
    )
  }
}

#Preview {
  TodoListDetailsAssembly.build()
}
