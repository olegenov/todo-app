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
    
    init?(from dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let text = dictionary["text"] as? String,
              let isDone = dictionary["isDone"] as? Bool,
              let createdAtRaw = dictionary["createdAt"] as? TimeInterval
        else {
            return nil
        }
        
        self.id = id
        self.text = text
        self.isDone = isDone
        self.createdAt = Date(timeIntervalSince1970: createdAtRaw)
        
        let importanceString = dictionary["importance"] as? String ?? ""
        
        switch importanceString {
            case Importance.low.rawValue:
                importance = .low
            case Importance.high.rawValue:
                importance = .high
            default:
                importance = .medium
        }
        
        if let deadlineRaw = dictionary["deadline"] as? TimeInterval {
            deadline = Date(timeIntervalSince1970: deadlineRaw)
        } else {
            deadline = nil
        }
        
        if let changedAtRaw = dictionary["changedAt"] as? TimeInterval {
            changedAt = Date(timeIntervalSince1970: changedAtRaw)
        } else {
            changedAt = nil
        }
    }
}

extension TodoItem {
    static func parse(json: Any) -> TodoItem? {
        guard let data = json as? Data else {
            return nil
        }
        
        do {
            guard let item = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                return nil
            }
            
            return TodoItem(from: item)
        } catch {
            return nil
        }
        
    }
    
    var json: Any {
        var properties: [String: Any] = [
            "id": id,
            "text": text,
            "isDone": isDone,
            "createdAt": createdAt.timeIntervalSince1970
        ]
        
        if importance != .medium {
            properties["importance"] = importance.rawValue
        }
        
        if let deadline = deadline {
            properties["deadline"] = deadline.timeIntervalSince1970
        }
        
        if let changedAt = changedAt {
            properties["changedAt"] = changedAt.timeIntervalSince1970
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: properties)
            
            return jsonData
        } catch {
            return Data()
        }
    }
}

