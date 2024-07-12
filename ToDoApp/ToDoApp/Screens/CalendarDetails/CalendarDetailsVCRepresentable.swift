//
//  CalendarDetailsVCRepresentable.swift
//  ToDoApp
//

import SwiftUI

struct CalendarDetailsVCRepresentable: UIViewControllerRepresentable {
  @ObservedObject var listViewModel: TodoListDetailsViewModel
  @State var showsModal: Bool = false

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
    guard let viewModel = uiViewController.viewModel else {
      Logger.shared.logInfo("Failed to update Calendar view")

      return
    }

    if !listViewModel.isModalPresented && viewModel.isAddModalPresented {
      uiViewController.dismiss(animated: true)
      viewModel.isAddModalPresented = false

      uiViewController.configureData()
    }
  }
}
