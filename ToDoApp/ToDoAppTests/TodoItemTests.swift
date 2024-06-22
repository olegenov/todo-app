//
//  ToDoItemTests.swift
//  ToDoItemTests
//

import XCTest
@testable import ToDoApp

final class TodoItemTests: XCTestCase {
  
  func testJsonSerialization() {
    let id = "1234"
    let text = "Finish Mobile School homework 1"
    let importance = TodoItem.Importance.high
    let deadline = Date.now
    let createdAt = Date.now
    let isDone = true

    let item = TodoItem(id: id, text: text, importance: importance,
                        deadline: deadline, isDone: isDone, createdAt: createdAt)

    let jsonData = item.json
    
    XCTAssertNotNil(jsonData)
    
    do {
      guard let jsonObject = try JSONSerialization.jsonObject(with: jsonData as! Data) as? [String: Any] else {
        XCTFail("Failed to parse JSON")
        
        return
      }
      
      XCTAssertEqual(jsonObject["id"] as? String, id)
      XCTAssertEqual(jsonObject["text"] as? String, text)
      XCTAssertEqual(jsonObject["importance"] as? String, importance.rawValue)
      XCTAssertEqual(jsonObject["deadline"] as? TimeInterval, deadline.timeIntervalSince1970)
      XCTAssertEqual(jsonObject["isDone"] as? Bool, isDone)
      XCTAssertEqual(jsonObject["createdAt"] as? TimeInterval, createdAt.timeIntervalSince1970)
      XCTAssertNil(jsonObject["changedAt"])
    } catch {
      XCTFail("Failed to parse JSON")
    }
  }
  
  func testJsonSerializationSpecifics() {
    let text = "Finish Mobile School homework 1"
    let importance = TodoItem.Importance.medium
    let createdAt = Date.now
    
    let item = TodoItem(text: text, importance: importance)

    let jsonData = item.json
    
    XCTAssertNotNil(jsonData)
    
    do {
      guard let jsonObject = try JSONSerialization.jsonObject(with: jsonData as! Data) as? [String: Any] else {
        XCTFail("Failed to parse JSON")
        
        return
      }

      XCTAssertNil(jsonObject["importance"])
      XCTAssertNil(jsonObject["deadline"])
    } catch {
      XCTFail("Failed to parse JSON")
    }
  }
  
  func testJSONParsing() {
    let id = "1234"
    let text = "Finish Mobile School homework 1"
    let importance = TodoItem.Importance.high
    let deadline = Date.now
    let createdAt = Date.now
    let isDone = true
    
    let dict: [String: Any] = [
      "id": id,
      "text": text,
      "importance": importance.rawValue,
      "deadline": deadline.timeIntervalSince1970,
      "createdAt": createdAt.timeIntervalSince1970,
      "isDone": isDone
    ]
    
    do {
      let data = try JSONSerialization.data(withJSONObject: dict)

      let item = TodoItem.parse(json: data)
      
      XCTAssertNotNil(item)
      
      XCTAssertEqual(item?.id, id)
      XCTAssertEqual(item?.text, text)
      XCTAssertEqual(item?.importance.rawValue, importance.rawValue)
      XCTAssertEqual(item?.deadline?.timeIntervalSince1970, deadline.timeIntervalSince1970)
      XCTAssertEqual(item?.isDone, isDone)
      XCTAssertEqual(item?.createdAt.timeIntervalSince1970, createdAt.timeIntervalSince1970)
      XCTAssertNil(item?.changedAt)
    } catch {
      XCTFail("Failed to serialize JSON")
    }
  }
  
  func testCSVSerialization() {
    let id = "1234"
    let text = "Finish Mobile School homework 1"
    let importance = TodoItem.Importance.high
    let deadline = Date.now
    let createdAt = Date.now
    let isDone = true
    
    let item = TodoItem(id: id, text: text, importance: importance,
                        deadline: deadline, isDone: isDone, createdAt: createdAt)
    
    let csvString = item.csv()
    
    XCTAssertEqual(csvString, "\(id),\(text),\(importance.rawValue)," +
                   "\(deadline.timeIntervalSince1970),\(isDone),\(createdAt.timeIntervalSince1970)")
  }
  
  func testParseCsv() {
    let id = "1234"
    let text = "Finish Mobile School homework 1"
    let importance = TodoItem.Importance.high
    let deadline = Date.now
    let createdAt = Date.now
    let isDone = true
    
    let csvString = "\(id),\(text),\(importance.rawValue)," +
    "\(deadline.timeIntervalSince1970),\(isDone),\(createdAt.timeIntervalSince1970)"
    
    let parsedItem = TodoItem.parse(csv: csvString)
    
    XCTAssertNotNil(parsedItem)
    XCTAssertEqual(parsedItem?.id, id)
    XCTAssertEqual(parsedItem?.text, text)
    XCTAssertEqual(parsedItem?.importance, importance)
    XCTAssertEqual(parsedItem?.deadline?.timeIntervalSince1970, deadline.timeIntervalSince1970)
    XCTAssertEqual(parsedItem?.isDone, isDone)
    XCTAssertEqual(parsedItem?.createdAt.timeIntervalSince1970, createdAt.timeIntervalSince1970)
  }
  
  func testCSVParsingSpecifics() {
    let id = ""
    let text = "Hello, World!"
    let importance = ""
    let deadline = ""
    let createdAt = ""
    let isDone = ""
    
    let csvString = "\(id),\"\(text)\",\(importance)," +
    "\(deadline),\(isDone),\(createdAt)"
    
    let parsedItem = TodoItem.parse(csv: csvString)
    
    XCTAssertNotNil(parsedItem)
    XCTAssertEqual(parsedItem?.text, text)
  }
}
