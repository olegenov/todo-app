//
//  ToDoItem.swift
//  ToDoApp
//

import Foundation

struct TodoItem {
    enum Importance: String {
        case low = "неважная"
        case medium = "обычная"
        case high = "важная"
    }
    
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let createdAt: Date
    let changedAt: Date?
    
    init(id: String = UUID().uuidString, text: String, 
         importance: Importance, deadline: Date? = nil,
         isDone: Bool = false, createdAt: Date = Date(),
         changedAt: Date? = nil
        ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.createdAt = createdAt
        self.changedAt = changedAt
    }
}
