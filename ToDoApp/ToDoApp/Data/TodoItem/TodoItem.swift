//
//  ToDoItem.swift
//  ToDoApp
//

import Foundation

struct TodoItem: TodoItemData {
  enum Importance: String {
    case low = "low"
    case medium = "basic"
    case high = "important"
  }

  let id: String
  let text: String
  let importance: Importance
  let deadline: Date?
  let isDone: Bool
  let createdAt: Date
  let changedAt: Date?
  let color: String?

  init(
    id: String = UUID().uuidString,
    text: String,
    importance: Importance,
    deadline: Date? = nil,
    isDone: Bool = false,
    createdAt: Date = Date(),
    changedAt: Date? = nil,
    color: String? = nil
  ) {
    self.id = id
    self.text = text
    self.importance = importance
    self.deadline = deadline
    self.isDone = isDone
    self.createdAt = createdAt
    self.changedAt = changedAt
    self.color = color
  }
}

// MARK: - JSON Serializing Extension
extension TodoItem {
  init?(from dictionary: [String: Any]) {
    guard let id = dictionary["id"] as? String,
      let text = dictionary["text"] as? String,
      let isDone = dictionary["isDone"] as? Bool,
      let createdAtRaw = dictionary["created_at"] as? TimeInterval
    else {
      return nil
    }

    self.id = id
    self.text = text
    self.isDone = isDone
    self.createdAt = Date(timeIntervalSince1970: createdAtRaw)

    let importanceString = dictionary[
      "importance"
    ] as? String ?? Importance.medium.rawValue

    if let importanceEnum = Importance(
      rawValue: importanceString
    ) {
      importance = importanceEnum
    } else {
      importance = .medium
    }

    if let deadlineRaw = dictionary[
      "deadline"
    ] as? TimeInterval {
      deadline = Date(timeIntervalSince1970: deadlineRaw)
    } else {
      deadline = nil
    }

    if let changedAtRaw = dictionary[
      "changed_at"
    ] as? TimeInterval {
      changedAt = Date(timeIntervalSince1970: changedAtRaw)
    } else {
      changedAt = nil
    }

    if let colorString = dictionary[
      "color"
    ] as? String {
      color = colorString
    } else {
      color = nil
    }
  }

  static func parse(json: Any) -> TodoItem? {
    guard let data = json as? Data else {
      Logger.shared.logError(
        "Failed to parse data from json"
      )

      return nil
    }

    do {
      guard let item = try JSONSerialization.jsonObject(
        with: data
      ) as? [String: Any] else {
        Logger.shared.logError(
          "Failed to create TodoItem object"
        )

        return nil
      }

      return TodoItem(from: item)
    } catch {
      Logger.shared.logError(
        "Failed to serialize object from data"
      )

      return nil
    }
  }

  var json: Any {
    var properties: [String: Any] = [
      "id": id,
      "text": text,
      "done": isDone,
      "created_at": createdAt.timeIntervalSince1970
    ]

    if importance != .medium {
      properties["importance"] = importance.rawValue
    }

    if let deadline = deadline {
      properties[
        "deadline"
      ] = deadline.timeIntervalSince1970
    }

    if let changedAt = changedAt {
      properties[
        "changed_at"
      ] = changedAt.timeIntervalSince1970
    }

    do {
      let jsonData = try JSONSerialization.data(withJSONObject: properties)

      return jsonData
    } catch {
      Logger.shared.logError(
        "Failed to create json data for object \(self.id)"
      )

      return Data()
    }
  }
}

// MARK: - CSV Serializing Extension
extension TodoItem {
  static func parse(csv: String) -> TodoItem? {
    var elements: [String] = []
    var currentField = ""
    var insideQuotes = false

    for char in csv {
      switch char {
      case ",":
        if insideQuotes && currentField.last != nil && currentField.last != "\"" {
          currentField.append(char)
        } else if insideQuotes {
          elements.append(String(currentField.dropLast(1).dropFirst(1)))
          currentField = ""
          insideQuotes = false
        } else {
          elements.append(currentField)
          currentField = ""
          insideQuotes = false
        }
      case "\"":
        currentField.append(char)
        insideQuotes = true
      default:
        currentField.append(char)
      }
    }

    elements.append(currentField)

    guard elements.count >= 6 else {
      Logger.shared.logError("Failed to parse data from csv: \(csv)")

      return nil
    }

    var id = elements[0]
    let text = elements[1]
    let importanceRaw = elements[2]
    let deadlineRaw = elements[3]
    let isDoneRaw = elements[4]
    let createdAtRaw = elements[5]
    let changedAtRaw = elements.count > 6 ? elements[6] : nil

    if id.isEmpty {
      id = UUID().uuidString
    }

    let importance = Importance(rawValue: importanceRaw) ?? .medium
    var deadline: Date?

    if let timeInterval = TimeInterval(deadlineRaw) {
      deadline = Date(timeIntervalSince1970: timeInterval)
    }

    let isDone = Bool(isDoneRaw) ?? false
    var createdAt = Date.now

    if let timeInterval = TimeInterval(createdAtRaw) {
      createdAt = Date(timeIntervalSince1970: timeInterval)
    }

    var changedAt: Date?

    if let rawValue = changedAtRaw,
      let timeInterval = TimeInterval(rawValue) {
      changedAt = Date(timeIntervalSince1970: timeInterval)
    }

    return TodoItem(
      id: id,
      text: text,
      importance: importance,
      deadline: deadline,
      isDone: isDone,
      createdAt: createdAt,
      changedAt: changedAt
    )
  }

  func csv() -> String {
    let deadlineString = deadline?.timeIntervalSince1970.description ?? ""
    let changedAtString = changedAt?.timeIntervalSince1970.description ?? ""

    return """
    \(id),\(text),\(importance.rawValue),\
    \(deadlineString),\(isDone),\
    \(createdAt.timeIntervalSince1970)\
    \(changedAt != nil ? ",\(changedAtString)" : "")
    """
  }
}
