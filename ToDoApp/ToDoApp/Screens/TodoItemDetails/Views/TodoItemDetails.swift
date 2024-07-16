//
//  NewTodoItem.swift
//  ToDoApp
//

import SwiftUI

struct TodoItemDetails: View {
  @ObservedObject var viewModel: TodoItemDetailsViewModel
  @State var isEditingTextField = false

  @Environment(\.horizontalSizeClass)
  var horizontalSizeClass

  @Environment(\.verticalSizeClass)
  var verticalSizeClass

  var textInputField: some View {
    TextField(
      "Что надо сделать?",
      text: $viewModel.data.text,
      axis: .vertical
    )
      .padding(16)
      .background(Color.listRowBackground)
      .lineLimit(4...50)
      .overlay(
        Rectangle()
          .fill(viewModel.data.color)
          .frame(width: 5, height: nil),
        alignment: .trailing
      )
      .clipShape(.rect(cornerRadius: 16))
  }

  var saveButton: some View {
    Button("Сохранить") {
      viewModel.saveData()
      viewModel.close()
    }
  }

  var cancelButton: some View {
    Button("Отменить") {
      viewModel.close()
    }
  }

  var deleteButton: some View {
    Button(
      action: {
        viewModel.deleteData()
      },
      label: {
        Text("Удалить")
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color(UIColor.listRowBackground))
          .clipShape(.rect(cornerRadius: 16))
      }
    )
    .foregroundStyle(
      viewModel.data.text.isEmpty ? Color.secondary : Color.red
    )
  }

  var portraitFormView: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 16) {
        textInputField

        VStack(alignment: .leading) {
          ImportanceField(data: $viewModel.data)
          Divider()
          DeadlineField(data: $viewModel.data)
          Divider()
          ColorPickerField(data: $viewModel.data)
          Divider()
          CategoryField(data: $viewModel.data)
        }
        .padding(16)
        .background(Color.listRowBackground)
        .clipShape(.rect(cornerRadius: 16))

        deleteButton
      }
    }
  }

  var landscapeFormView: some View {
    HStack(alignment: .top, spacing: 16) {
      ScrollView(showsIndicators: false) {
        textInputField
          .onTapGesture {
            withAnimation {
              isEditingTextField = true
            }
          }
      }

      ScrollView(showsIndicators: false) {
        VStack(spacing: 16) {
          VStack(alignment: .leading) {
            ImportanceField(data: $viewModel.data)
            Divider()
            DeadlineField(data: $viewModel.data)
            Divider()
            ColorPickerField(data: $viewModel.data)
            Divider()
            CategoryField(data: $viewModel.data)
          }
          .padding(16)
          .background(Color.listRowBackground)
          .clipShape(.rect(cornerRadius: 16))

          deleteButton
        }
      }
    }
  }

  var body: some View {
    NavigationView {
      Group {
        if horizontalSizeClass == .compact && verticalSizeClass == .regular {
          portraitFormView
        } else {
          if isEditingTextField {
            textInputField
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .edgesIgnoringSafeArea(.all)
          } else {
            landscapeFormView
          }
        }
      }
      .padding(16)
      .background(Color.backgroundColor)
      .navigationBarTitle("Дело", displayMode: .inline)
      .navigationBarItems(
        leading: cancelButton,
        trailing: saveButton
          .disabled(viewModel.data.text.isEmpty || !viewModel.hasChanged)
      )
      .gesture(
        DragGesture().onChanged { _ in
          UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
          )
          isEditingTextField = false
        }
      )
    }
    .onAppear {
      Logger.shared.logInfo("TodoItemDetails view appeared")
    }
    .onDisappear {
      Logger.shared.logInfo("TodoItemDetails view disappeared")
    }
  }

  private func scrollToTextField(scrollView: ScrollViewProxy) {
    DispatchQueue.main.async {
      scrollView.scrollTo("textField", anchor: .bottom)
    }
  }
}
