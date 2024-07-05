//
//  CalendarDetailsViewController.swift
//  ToDoApp
//

import UIKit

class CalendarDetailsViewController: UIViewController {
  var viewModel: CalendarDetailsViewModel?
  private let table = TodoItemTable()
  private var sectionsView: DateCollection!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.backgroundColor
    
    sectionsView = DateCollection(table: table)
    configureData()
    
    configureUI()
  }
  
  func configureUI() {
    configureSections()
    configureTable()
  }
  
  func configureData() {
    var data = [(Date?, [RowData])]()
    
    guard let items = viewModel?.items else {
      return
    }
    
    for item in items {
      guard let index = data.firstIndex(where: { $0.0 == item.deadline?.dateOnly() }) else {
        data.append(
          (
            item.deadline?.dateOnly(),
            [RowData(
              id: item.id,
              text: item.text,
              date: item.deadline,
              isDone: item.isDone
            )]
          )
        )
        
        continue
      }
      
      data[index].1.append(RowData(id: item.id, text: item.text, date: item.deadline, isDone: item.isDone))
    }
    
    let sortedData = data
      .sorted(by: { $0.0 ?? Date.distantFuture < $1.0 ?? Date.distantFuture })
    
    
    table.updateData(sortedData)

    table.sectionScrollAction = { (index: Int) -> () in
      self.sectionsView.reloadData()
      self.sectionsView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    table.rightSwipeAction = { (id: String) -> () in
      self.viewModel?.completed(for: id)
    }
    
    table.leftSwipeAction = { (id: String) -> () in
      self.viewModel?.uncompleted(for: id)
    }
  }
  
  func configureSections() {
    view.addSubview(sectionsView)
    
    NSLayoutConstraint.activate([
      sectionsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      sectionsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      sectionsView.heightAnchor.constraint(equalToConstant: 90),
      sectionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      sectionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    ])
  }
  
  func configureTable() {
    view.addSubview(table)
    
    NSLayoutConstraint.activate([
      table.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      table.topAnchor.constraint(equalTo: sectionsView.bottomAnchor, constant: 8),
      table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
    ])
  }
}
