//
//  NewTodoItem.swift
//  ToDoApp
//

import SwiftUI

struct TodoItemDetails: View {
  @StateObject var viewModel: TodoItemDetailsViewModel
  
  var textInputField: some View {
    TextField("Что надо сделать?", text: $viewModel.data.text, axis: .vertical)
      .padding(16)
      .background(Color.listRowBackground)
      .lineLimit(4...50)
      .clipShape(.rect(cornerRadius: 16))
  }
  
  var saveButton: some View {
    Button("Сохранить") {
      
    }
  }
  
  var cancelButton: some View {
    Button("Отменить") {
    }
  }
  
  var deleteButton: some View {
    Button(action: {
      viewModel.deleteData()
    }) {
      Text("Удалить")
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.listRowBackground))
        .clipShape(.rect(cornerRadius: 16))
    }
    .foregroundStyle(viewModel.data.text.isEmpty ? Color.secondary : Color.red)
  }
  
  var body: some View {
    NavigationView {
      ScrollView(showsIndicators: false) {
        VStack(spacing: 16) {
          textInputField
          
          VStack {
            ImportanceField(data: $viewModel.data)
            Divider()
            DeadlineField(data: $viewModel.data)
          }
          .padding(16)
          .background(Color.listRowBackground)
          .clipShape(.rect(cornerRadius: 16))
          
          deleteButton
        }
        .padding(16)
        
        Spacer()
      }
      .navigationBarTitle("Дело", displayMode: .inline)
      .navigationBarItems(
        leading: cancelButton,
        trailing: saveButton
          .disabled(viewModel.data.text.isEmpty || !viewModel.hasChanged)
      )
      .background(Color.background)
    }
    .onAppear() {
      viewModel.loadData()
    }
  }
}
