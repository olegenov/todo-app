//
//  TodoListDetails.swift
//  ToDoApp
//

import SwiftUI

struct TodoListDetails: View {
  @ObservedObject var viewModel: TodoListDetailsViewModel
  @State private var showCompleted: Bool = false
  @State private var showCalendarView = false
  @State private var loaded = false

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
    Button(
      action: {
        viewModel.openNewItemModal()
      },
      label: {
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
        .shadow(
          color: Color(
            UIColor(
              red: 0 / 255,
              green: 73 / 255,
              blue: 153 / 255,
              alpha: 0.3
            )
          ),
          radius: 20,
          x: 0,
          y: 8
        )
      }
    )
  }

  var todoList: some View {
    List {
      Section {
        if !loaded {
          Text("loading...")
            .foregroundStyle(Color.iconColor)
        }

        ForEach(viewModel.items) { item in
          if !item.isDone || showCompleted {
            TodoItemRow(
              item: item,
              checkMarkAction: { item in
                viewModel.toggleComplited(for: item)
              },
              editAction: viewModel.openEditItemModal
            )
            .modifier(
              ItemRowActionsModifier(
                item: item,
                deleteAction: { viewModel.removeTodoItem(by: item.id) },
                editAction: { viewModel.openEditItemModal(for: item) },
                toggleAction: { viewModel.toggleComplited(for: item) }
              )
            )
            .listRowBackground(Color.listRowBackground)
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
    .scrollContentBackground(.hidden)
  }

  var errorsStack: some View {
    VStack {
      ForEach(viewModel.errors) { error in
        ErrorView(
          text: error.message
        ) {
          withAnimation {
            viewModel.errors = []
          }
        }
      }
    }
  }

  var body: some View {
    NavigationStack {
      ZStack {
        todoList
          .padding(.horizontal, -16)
          .navigationTitle("Мои дела")
      }
      .background(Color.backgroundColor)

      errorsStack

        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Button(
              action: {
                showCalendarView.toggle()
              },
              label: {
                Image(systemName: "calendar")
              }
            )
          }

          ToolbarItem(placement: .topBarTrailing) {
            if viewModel.isOfflineMode {
              Image(systemName: "network.slash")
                .foregroundStyle(Color.iconColor)
            }
          }

          ToolbarItem(placement: .topBarTrailing) {
            Button(
              action: {
                viewModel.isSettingsPresented.toggle()
              },
              label: {
                Image(systemName: "gear")
              }
            )
          }

          ToolbarItem(placement: .navigation) {
            ActivityIndicator(amountOfRequests: $viewModel.amountOfRequests)
          }

          ToolbarItem(placement: .bottomBar) {
            addButton
          }
        }
    }
    .refreshable {
      await viewModel.loadTodoItems()
    }
    .padding(.horizontal, 16)
    .background(Color.backgroundColor)
    .sheet(isPresented: $viewModel.isModalPresented) {
      if let item = viewModel.selectedItem {
        viewModel.getModalView(for: item)
      }
    }
    .fullScreenCover(isPresented: $viewModel.isSettingsPresented) {
      NavigationStack {
        viewModel.getSettingsView()
          .navigationTitle("Настройки")
          .navigationBarTitleDisplayMode(.inline)
          .toolbar {
            ToolbarItem(placement: .topBarLeading) {
              Button(
                action: {
                  viewModel.isSettingsPresented.toggle()
                },
                label: {
                  Image(systemName: "chevron.backward")
                    .padding(16)
                }
              )
            }
          }
      }
    }
    .fullScreenCover(isPresented: $showCalendarView) {
      NavigationStack {
        viewModel.getCalendarView()
          .background(Color.backgroundColor)
          .navigationTitle("Мои дела")
          .navigationBarTitleDisplayMode(.inline)
          .toolbar {
            ToolbarItem(placement: .topBarLeading) {
              Button(
                action: {
                  showCalendarView.toggle()
                },
                label: {
                  Image(systemName: "chevron.backward")
                    .padding(.horizontal, 16)
                }
              )
            }
          }
      }
    }
    .onAppear {
      Logger.shared.logInfo("TodoListDetails view appeared")
    }
    .onDisappear {
      Logger.shared.logInfo("TodoListDetails view disappeared")
    }
    .task {
      await viewModel.loadTodoItems()
      self.loaded = true
    }
  }
}

#Preview {
  TodoListDetailsAssembly.build()
}
