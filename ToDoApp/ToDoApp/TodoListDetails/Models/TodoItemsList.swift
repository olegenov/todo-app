//
//  TodoItemsList.swift
//  ToDoApp
//

import Foundation

class TodoItemsList: ObservableObject {
  @Published var items = [
    TodoItemModel(
      id: UUID().uuidString,
      text: "Купить сыр",
      deadline: nil,
      isDone: false
    ),
    TodoItemModel(
      id: UUID().uuidString,
      text: "Сделать пиццу",
      deadline: nil,
      isDone: true
    ),
    TodoItemModel(
      id: UUID().uuidString,
      text: "Задание",
      deadline: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 14)),
      isDone: false
    ),
    TodoItemModel(
      id: UUID().uuidString,
      text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно",
      deadline: nil,
      isDone: false
    ),
    TodoItemModel(
      id: UUID().uuidString,
      text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обреза…",
      deadline: nil,
      isDone: false
    )
  ]
  
  func toggleComplited(for item: TodoItemModel) {
    if let index = items.firstIndex(where: { $0.id == item.id }) {
      items[index].isDone.toggle()
    }
  }
}
