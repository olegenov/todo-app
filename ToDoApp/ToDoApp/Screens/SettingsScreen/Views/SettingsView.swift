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
      .disabled(viewModel.data.text.isEmpty)
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
    VStack(alignment: .leading, spacing: 8) {
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
        
        Spacer()
        
        HStack(spacing: 8) {
          doneIcon
          
          cancelIcon
        }
      }
      
      if (pickerShown) {
        CustomColorPicker(data: $viewModel.data.color)
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
              .padding(8)
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

