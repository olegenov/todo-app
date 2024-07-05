//
//  TaskTable.swift
//  ToDoApp
//

import UIKit

class TodoItemTable: UITableView {
  var selectedDateIndex: Int = 0
  var rightSwipeAction: ((String) -> Void)?
  var leftSwipeAction: ((String) -> Void)?
  var sectionScrollAction: ((Int) -> Void)?
  
  var data = [(Date?, [RowData])]()
  
  func updateData(_ data: [(Date?, [RowData])]) {
    self.data = data
    
    reloadData()
  }
  
  init() {
    super.init(frame: .zero, style: .plain)
    
    delegate = self
    dataSource = self
    
    register(TaskCell.self, forCellReuseIdentifier: "taskCell")
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureUI() {
    backgroundColor = UIColor.backgroundColor
    allowsSelection = false
    translatesAutoresizingMaskIntoConstraints = false
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TodoItemTable: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data[section].1.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard let sectionDate = data[section].0 else {
      return "Другое"
    }
    
    return sectionDate.toString()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
    let section = indexPath.section
    let index = indexPath.row
    
    let task = data[section].1[index]
    
    cell.setupSwipe(
      leftSipeAction: { self.leftSwiped(section: section, index: index) },
      rightSwipeAction: { self.rightSwiped(section: section, index: index) }
    )
    
    if task.isDone {
      cell.crossedOut = true
      cell.completeCrossOut(text: task.text)
    } else {
      cell.crossedOut = false
      cell.completeCrossOut(text: task.text)
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView,
                 didEndDisplayingHeaderView view: UIView,
                 forSection section: Int) {
    if section == selectedDateIndex {
      let currentSection = section + 1 < data.count ? section + 1 : 0
      selectedDateIndex = currentSection
      sectionScrollAction?(currentSection)
    }
  }
  
  func tableView(_ tableView: UITableView,
                 willDisplayHeaderView view: UIView,
                 forSection section: Int) {
    if section < selectedDateIndex {
      selectedDateIndex = section
      sectionScrollAction?(section)
    }
  }
  
  @objc func rightSwiped(section: Int, index: Int) {
    data[section].1[index].isDone = true
    reloadData()
    rightSwipeAction?(data[section].1[index].id)
  }
  
  @objc func leftSwiped(section: Int, index: Int) {
    data[section].1[index].isDone = false
    reloadData()
    leftSwipeAction?(data[section].1[index].id)
  }
}
