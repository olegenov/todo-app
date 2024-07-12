//
//  CalendarDetailsViewModel.swift
//  ToDoApp
//

import SwiftUI

class CalendarDetailsViewModel {
  var listViewModel: TodoListDetailsViewModel?
  var closeModalAction: (() -> Void)?
  
  var isModalPresented: Bool = false {
    didSet {
      if !isModalPresented {
        closeModalAction?()
      }
    }
  }
  
  var isAddModalPresented: Bool = false
  
  var items: [TodoItemModel] {
    return listViewModel?.items ?? []
  }
  
  func completed(for id: String) {
    guard let item = listViewModel?.items.first(where: { $0.id == id }) else {
      Logger.shared.logError("Failed to find item for id: \(id)")
      
      return
    }
    
    listViewModel?.completeItem(for: item)
  }
  
  func uncompleted(for id: String) {
    guard let item = listViewModel?.items.first(where: { $0.id == id }) else {
      Logger.shared.logError("Failed to find item for id: \(id)")
      
      return
    }
    
    listViewModel?.uncompleteItem(for: item)
  }
  
  func getAddModal() -> UIViewController {
    guard let viewModel = listViewModel else {
      Logger.shared.logError("Failed to get viewModel from TodoListDetails")
      
      return UIViewController()
    }
    
    let view = TodoItemDetailsAssembly.build(item: TodoItemModel(id: UUID().uuidString), listViewModel: viewModel)
    
    let hostingController = UIHostingController(rootView: view)
    
    return hostingController
  }
}
