//
//  CategoryField.swift
//  ToDoApp
//

import SwiftUI

struct CategoryField: View {
  @State private var isExpanded = false
  @Binding var data: TodoItemFormData
  
  func pickerItem(category: CategoryModel) -> some View {
    HStack(spacing: 8) {
      Circle()
        .frame(width: 24, height: 24)
        .foregroundStyle(Color.getColor(hex: category.color) ?? Color.clear)
      
      Text(category.name)
    }
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack(spacing: 8) {
        Circle()
          .fill(Color.getColor(hex: data.category.color) ?? Color.clear)
          .frame(width: 24, height: 24)
        Text("Категория")
        
        Image(systemName: "chevron.down")
          .rotationEffect(.degrees(isExpanded ? 180 : 0))
          .onTapGesture {
            withAnimation {
              isExpanded.toggle()
            }
          }
      }
      .padding(.vertical, 8)
      if isExpanded {
        picker
      }
    }
  }
  
  var picker: some View {
    Picker("Категория", selection: $data.category) {
      Text("Без категории")
        .tag(CategoryModel.empty)
      
      ForEach(CategoryManager.shared.categories) { category in
        pickerItem(category: category)
          .tag(category)
      }
    }
    .pickerStyle(.wheel)
  }
}
