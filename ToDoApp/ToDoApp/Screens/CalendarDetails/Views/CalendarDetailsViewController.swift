//
//  CalendarDetailsViewController.swift
//  ToDoApp
//

import UIKit

class CalendarDetailsViewController: UIViewController {
  private enum Constants {
    static let sectionsHeight: CGFloat = 90

    static let horizontalPadding: CGFloat = 16
    static let tableBottomOffset: CGFloat = 100
    static let sectionGap: CGFloat = 8

    static let buttonColorR: CGFloat = 0 / 255
    static let buttonColorG: CGFloat = 73 / 255
    static let buttonColorB: CGFloat = 153 / 255
    static let buttonColorOpacity: CGFloat = 0.3
    static let butonRadius: CGFloat = 20
    static let buttonShadowOffset: (CGFloat, CGFloat) = (
      0, 8
    )
    static let buttonShadowOpacity: Float = 1
    static let buttonSize: CGFloat = 44
    static let buttonPointSize: CGFloat = 36
  }

  var viewModel: CalendarDetailsViewModel?
  private let table = TodoItemTable()
  private var sectionsView: DateCollection?

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
    var data: [(Date?, [RowData])] = []

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
            [
              RowData(
                id: item.id,
                text: item.text,
                date: item.deadline,
                isDone: item.isDone,
                category: item.category.color
              )
            ]
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
      .sorted {
        $0.0 ?? Date.distantFuture < $1.0 ?? Date.distantFuture
      }


    table.updateData(sortedData)
    sectionsView?.reloadData()
  }

  func configureTableActions() {
    table.sectionScrollAction = { (index: Int) in
      self.sectionsView?.reloadData()
      self.sectionsView?.scrollToItem(
        at: IndexPath(item: index, section: 0),
        at: .centeredHorizontally,
        animated: true
      )
    }

    table.rightSwipeAction = { (id: String) in
      self.viewModel?.completed(for: id)
    }

    table.leftSwipeAction = { (id: String) in
      self.viewModel?.uncompleted(for: id)
    }
  }

  func configureSections() {
    guard let sections = sectionsView else {
      return
    }

    view.addSubview(sections)

    NSLayoutConstraint.activate([
      sections.centerXAnchor.constraint(
        equalTo: view.centerXAnchor
      ),
      sections.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor
      ),
      sections.heightAnchor.constraint(
        equalToConstant: Constants.sectionsHeight
      ),
      sections.leadingAnchor.constraint(
        equalTo: view.leadingAnchor,
        constant: Constants.horizontalPadding
      ),
      sections.trailingAnchor.constraint(
        equalTo: view.trailingAnchor,
        constant: -Constants.horizontalPadding
      )
    ])
  }

  func configureTable() {
    table.contentInset.bottom = Constants.tableBottomOffset

    guard let sections = sectionsView else {
      return
    }

    view.addSubview(table)

    NSLayoutConstraint.activate([
      table.leadingAnchor.constraint(
        equalTo: view.leadingAnchor,
        constant: Constants.horizontalPadding
      ),
      table.trailingAnchor.constraint(
        equalTo: view.trailingAnchor,
        constant: -Constants.horizontalPadding
      ),
      table.topAnchor.constraint(
        equalTo: sections.bottomAnchor,
        constant: Constants.sectionGap
      ),
      table.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor
      )
    ])
  }

  func configureAddButton() {
    let button = UIButton()

    var configuration = UIButton.Configuration.plain()

    configuration.image = UIImage(
      systemName: "plus.circle.fill"
    )
    configuration.imagePadding = 0
    configuration.imagePlacement = .all

    configuration.preferredSymbolConfigurationForImage = UIImage
      .SymbolConfiguration(pointSize: Constants.buttonPointSize)

    button.configuration = configuration

    button.layer.shadowColor = UIColor(
      red: Constants.buttonColorR,
      green: Constants.buttonColorG,
      blue: Constants.buttonColorB,
      alpha: Constants.buttonColorOpacity
    ).cgColor

    button.layer.shadowRadius = Constants.butonRadius
    button.layer.shadowOffset = CGSize(
      width: Constants.buttonShadowOffset.0,
      height: Constants.buttonShadowOffset.1
    )
    button.layer.shadowOpacity = Constants.buttonShadowOpacity
    button.layer.masksToBounds = false

    button.translatesAutoresizingMaskIntoConstraints = false

    button.addTarget(self, action: #selector(openAddModalAction), for: .touchUpInside)

    view.addSubview(button)

    NSLayoutConstraint.activate([
      button.heightAnchor.constraint(
        equalToConstant: Constants.buttonSize
      ),
      button.widthAnchor.constraint(
        equalToConstant: Constants.buttonSize
      ),
      button.centerXAnchor.constraint(
        equalTo: view.centerXAnchor
      ),
      button.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor,
        constant: -Constants.horizontalPadding
      )
    ])
  }

  @objc func openAddModalAction() {
    let addVc = viewModel?.getAddModal()

    guard let addViewController = addVc else {
      return
    }

    viewModel?.isAddModalPresented = true

    present(addViewController, animated: true)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    Logger.shared.logInfo("CalendarDetails view appeared")
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    Logger.shared.logInfo("CalendarDetails view disappeared")
  }
}
