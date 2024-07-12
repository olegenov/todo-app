//
//  SettingsViewController.swift
//  ToDoApp
//

import SwiftUI

struct SettingsView: View {
  @ObservedObject var viewModel: SettingsViewModel
  @State var creationMode: Bool = false
  @State var pickerShown: Bool = false
  
  var doneIcon: some View {
    Image(systemName: "checkmark.circle.fill")
      .resizable()
      .frame(width: 20, height: 20)
      .foregroundStyle(Color.blue)
      .onTapGesture {
        withAnimation {
          doneCreation()
        }
      }
  }
  
  var cancelIcon: some View {
    Image(systemName: "x.circle.fill")
      .resizable()
      .frame(width: 20, height: 20)
      .foregroundStyle(Color.red)
      .onTapGesture {
        withAnimation {
          cancelCreation()
        }
      }
  }
  
  var additionRow: some View {
    Text("Добавить категорию")
      .opacity(0.3)
      .padding([.leading], 40)
      .padding(.vertical, 8)
      .onTapGesture {
        withAnimation {
          creationMode.toggle()
        }
      }
  }
  
  var form: some View {
    VStack(alignment: .leading) {
      HStack(spacing: 8) {
        Circle()
          .frame(width: 24, height: 24)
          .foregroundStyle(viewModel.data.color)
          .onTapGesture {
            withAnimation {
              pickerShown.toggle()
            }
          }
        
        TextField("Новая категория", text: $viewModel.data.text, axis: .horizontal)
          .lineLimit(1)
        
        HStack(spacing: 8) {
          doneIcon
            .disabled(viewModel.data.text.isEmpty)
          
          cancelIcon
        }
      }
      .padding(8)
      
      if (pickerShown) {
        CustomColorPicker(data: $viewModel.data.color, width: UIScreen.main.bounds.width - 2 * 48)
          .frame(height: 30)
          .padding(.horizontal, 8)
          .padding(.vertical, 16)
      }
    }
  }
  
  var body: some View {
    VStack {
      List {
        Section("Категории") {
          ForEach(CategoryManager.shared.categories) { category in
            HStack(spacing: 8) {
              Circle()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.getColor(hex: category.color) ?? Color.clear)
              
              Text(category.name)
            }
            .padding(8)
          }
          
          if !creationMode {
            additionRow
          } else {
            form
          }
        }
        .listRowBackground(Color.listRowBackground)
      }
      .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
    }
    .background(Color.backgroundColor)
    .listStyle(.insetGrouped)
    .scrollClipDisabled(false)
    .scrollContentBackground(.hidden)
    .gesture(
      DragGesture().onChanged{ _ in
        UIApplication.shared.sendAction(
          #selector(UIResponder.resignFirstResponder),
          to: nil,
          from: nil,
          for: nil
        )
      }
    )
    .onAppear {
      Logger.shared.logInfo("Settings view appeared")
    }
    .onDisappear() {
      Logger.shared.logInfo("Settings view disappeared")
    }
  }
  
  func doneCreation() {
    viewModel.saveCategory()
    viewModel.clear()
    
    creationMode = false
    pickerShown = false
  }
  
  func cancelCreation() {
    viewModel.clear()
    
    creationMode = false
    pickerShown = false
  }
}

