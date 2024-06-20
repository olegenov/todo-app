//
//  FileCache.swift
//  ToDoApp
//
//  Created by Никита Китаев on 20.06.2024.
//

import Foundation

class FileCache {
    private(set) var todoItems: [TodoItem] = []
    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    
    func addTodoItem(_ item: TodoItem) {
        if !todoItems.contains(where: { $0.id == item.id }) {
            todoItems.append(item)
        }
    }
    
    func removeTodoItem(by id: String) {
        todoItems.removeAll { $0.id == id }
    }
    
    func save(to filename: String) {
        guard let fileURL = getDocumentsDirectory()?.appending(component: filename) else {
            return
        }
        
        for item in todoItems {
            if let data = item.json as? Data {
                do {
                    try data.write(to: fileURL)
                } catch {
                    continue
                }
            }
        }
    }
    
    func load(from filename: String) throws {
        guard let fileURL = getDocumentsDirectory()?.appending(component: filename) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            var loadedItems = [TodoItem]()
            
            if let parsedItem = TodoItem.parse(json: data) {
                loadedItems.append(parsedItem)
            }
            
            todoItems = loadedItems
            
        } catch {
            return
        }
    }
    
    private func getDocumentsDirectory() -> URL? {
        return fileManager.urls(for: .applicationDirectory, in: .userDomainMask).first
    }
}
