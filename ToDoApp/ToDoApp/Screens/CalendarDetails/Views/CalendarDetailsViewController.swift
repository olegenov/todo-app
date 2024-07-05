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
    configureTableActions()
    configureUI()
  }
  
  func configureUI() {
    configureSections()
    configureTable()
    
    configureAddButton()
  }
  
  func configureData() {
    var data = [(Date?, [RowData])]()
    
    guard let items = viewModel?.items else {
      return
    }
    
    for item in items {
      guard let index = data.firstIndex(
        where: {
          $0.0 == item.deadline?.dateOnly()
        }
      ) else {
        data.append(
          (
            item.deadline?.dateOnly(),
            [RowData(
              id: item.id,
              text: item.text,
              date: item.deadline,
              isDone: item.isDone,
              category: item.category.color
            )]
          )
        )
        
        continue
      }
      
      data[index].1.append(
        RowData(
          id: item.id,
          text: item.text,
          date: item.deadline,
          isDone: item.isDone,
          category: item.category.color
        )
      )
    }
    
    let sortedData = data
      .sorted(by: { $0.0 ?? Date.distantFuture < $1.0 ?? Date.distantFuture })
    
    
    table.updateData(sortedData)
  }
  
  func configureTableActions() {
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
    table.contentInset.bottom = 100
    
    view.addSubview(table)
    
    NSLayoutConstraint.activate([
      table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      table.topAnchor.constraint(equalTo: sectionsView.bottomAnchor, constant: 8),
      table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  func configureAddButton() {
    let button = UIButton()
    
    var configuration = UIButton.Configuration.plain()
    configuration.image = UIImage(systemName: "plus.circle.fill")
    configuration.imagePadding = 0
    configuration.imagePlacement = .all
    
    configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 36)
    
    button.configuration = configuration
    
    button.layer.shadowColor = UIColor(red: 0/255, green: 73/255, blue: 153/255, alpha: 0.3).cgColor
    button.layer.shadowRadius = 20
    button.layer.shadowOffset = CGSize(width: 0, height: 8)
    button.layer.shadowOpacity = 1
    button.layer.masksToBounds = false
    
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.addTarget(self, action: #selector(openAddModalAction), for: .touchUpInside)
    
    view.addSubview(button)
    
    NSLayoutConstraint.activate([
      button.heightAnchor.constraint(equalToConstant: 44),
      button.widthAnchor.constraint(equalToConstant: 44),
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
    ])
  }
  
  @objc func openAddModalAction() {
    let addVc = viewModel?.getAddModal()
    
    guard let vc = addVc else {
      return
    }
    
    viewModel?.isAddModalPresented = true
    
    present(vc, animated: true)
  }
}
