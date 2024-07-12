//
//  CalendarDetailsAssembly.swift
//  ToDoApp
//

import Foundation
import CocoaLumberjack

enum CalendarDetailsAssembly {
  static func build(listViewModel: TodoListDetailsViewModel) -> CalendarDetailsViewController {
    let vc =  CalendarDetailsViewController()
    let viewModel = CalendarDetailsViewModel()
    viewModel.listViewModel = listViewModel
    
    vc.viewModel = viewModel
    
    return vc
  }
}
