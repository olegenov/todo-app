//
//  TodoItemsListDetailsViewModel.swift
//  ToDoApp
//

import SwiftUI

class TodoListDetailsViewModel: ObservableObject {
  @Published var items: [TodoItemModel] = []
  @Published var isModalPresented: Bool = false
  @Published var isSettingsPresented: Bool = false
  @Published var selectedItem: TodoItemModel?
  
  var calendarView: CalendarDetailsVCRepresentable? = nil

  
  func addTodoItem(_ item: TodoItemModel) {
    if items.contains(where: { $0.id == item.id }) {
      Logger.shared.logWarning("Failed to add existing TodoItem with id \(item.id) to FileCache list")
      
      return
    }
    
    items.append(item)
  }

  func removeTodoItem(by id: String) {
    items.removeAll(where: { $0.id == id })
  }
  
  func toggleComplited(for item: TodoItemModel) {
    let updatedItem = TodoItemModel(
      id: item.id,
      text: item.text,
      importance: item.importance,
      deadline: item.deadline,
      isDone: !item.isDone,
      createdAt: item.createdAt,
      color: item.color
    )
    
    removeTodoItem(by: item.id)
    addTodoItem(updatedItem)
  }
  
  func completeItem(for item: TodoItemModel) {
    let updatedItem = TodoItemModel(
      id: item.id,
      text: item.text,
      importance: item.importance,
      deadline: item.deadline,
      isDone: true,
      createdAt: item.createdAt,
      color: item.color,
      category: item.category
    )
    
    removeTodoItem(by: item.id)
    addTodoItem(updatedItem)
  }
  
  func uncompleteItem(for item: TodoItemModel) {
    let updatedItem = TodoItemModel(
      id: item.id,
      text: item.text,
      importance: item.importance,
      deadline: item.deadline,
      isDone: false,
      createdAt: item.createdAt,
      color: item.color,
      category: item.category
    )
    
    removeTodoItem(by: item.id)
    addTodoItem(updatedItem)
  }
  
  func updateTodoItem(with item: TodoItemModel) {
    let updatedItem = TodoItemModel(
      id: item.id,
      text: item.text,
      importance: item.importance,
      deadline: item.deadline,
      isDone: item.isDone,
      createdAt: item.createdAt,
      color: item.color,
      category: item.category
    )
    
    removeTodoItem(by: item.id)
    addTodoItem(updatedItem)
  }
    
  func openNewItemModal() {
    self.selectedItem = TodoItemModel(id: UUID().uuidString)
    self.isModalPresented = true
  }
  
  func openEditItemModal(for item: TodoItemModel) {
    self.selectedItem = item
    self.isModalPresented = true
  }
  
  func closeModal() {
    self.isModalPresented = false
    self.selectedItem = nil
  }
  
  func deleteItem(at offsets: IndexSet) {
    items.remove(atOffsets: offsets)
  }
  
  func getModalView(for item: TodoItemModel) -> TodoItemDetails {
    TodoItemDetailsAssembly.build(
      item: item,
      listViewModel: self
    )
  }
  
  func getSettingsView() -> SettingsView {
    SettingsScreenAssembly.build()
  }
  
  func getCalendarView() -> CalendarDetailsVCRepresentable? {
    if self.calendarView != nil {
      return calendarView
    }
    
    let view = CalendarDetailsVCRepresentable(listViewModel: self)
    
    self.calendarView = view
    
    return calendarView
  }
}
