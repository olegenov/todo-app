//
//  CalendarDetailsVCRepresentable.swift
//  ToDoApp
//

import SwiftUI

struct CalendarDetailsVCRepresentable: UIViewControllerRepresentable {
  let listViewModel: TodoListDetailsViewModel
  
  func makeUIViewController(
    context: Context
  ) -> CalendarDetailsViewController {
    let vc = CalendarDetailsAssembly.build(listViewModel: listViewModel)
    
    return vc
  }
  
  func updateUIViewController(
    _ uiViewController: CalendarDetailsViewController,
    context: Context
  ) {
    // …
  }
}
