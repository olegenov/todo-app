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
         changedAt: Date? = nil) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.createdAt = createdAt
        self.changedAt = changedAt
    }
}

extension TodoItem {
    static func parse(json: Any) -> TodoItem? {
        guard let data = json as? [String: Any], let id = data["id"] as? String,
              let text = data["text"] as? String, let isDone = data["isDone"] as? Bool,
              let createdAtTimestamp = data["createdAt"] as? TimeInterval else {
            return nil
        }
        
        let importanceRaw = data["importance"] as? String
        let importance = Importance(rawValue: importanceRaw ?? Importance.medium.rawValue) ?? .medium
        
        let createdAt = Date(timeIntervalSince1970: createdAtTimestamp)
        
        let changedAtRaw = data["changedAt"] as? TimeInterval
        let changedAt = changedAtRaw != nil ? Date(timeIntervalSince1970: changedAtRaw!) : nil
        
        let deadlineRaw = data["deadline"] as? TimeInterval
        let deadline = deadlineRaw != nil ? Date(timeIntervalSince1970: deadlineRaw!) : nil
        
        return TodoItem(id: id, text: text, importance: importance, deadline: deadline,
                        isDone: isDone, createdAt: createdAt, changedAt: changedAt)
    }
}
