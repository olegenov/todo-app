//
//  TodoItemsListDetailsViewModel.swift
//  ToDoApp
//

import Foundation

class TodoListDetailsViewModel: ObservableObject {
  @Published var items: [TodoItemModel] = []
  @Published var isModalPresented: Bool = false
  @Published var selectedItem: TodoItemModel?
  
  func addTodoItem(_ item: TodoItemModel) {
    if items.contains(where: { $0.id == item.id }) {
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
      isDone: !item.isDone,
      createdAt: item.createdAt
    )
    
    removeTodoItem(by: item.id)
    addTodoItem(updatedItem)
  }
  
  func completeItem(for item: TodoItemModel) {
    let updatedItem = TodoItemModel(
      id: item.id,
      text: item.text,
      importance: item.importance,
      isDone: true,
      createdAt: item.createdAt
    )
    
    removeTodoItem(by: item.id)
    addTodoItem(updatedItem)
  }
  
  func uncompleteItem(for item: TodoItemModel) {
    let updatedItem = TodoItemModel(
      id: item.id,
      text: item.text,
      importance: item.importance,
      isDone: false,
      createdAt: item.createdAt
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
      createdAt: item.createdAt
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
}
