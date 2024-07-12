//
//  DateCollection.swift
//  ToDoApp
//

import UIKit

class DateCollection: UICollectionView {
  var table: TodoItemTable

  init(table: TodoItemTable) {
    self.table = table

    let layout = UICollectionViewFlowLayout()

    layout.scrollDirection = .horizontal

    super.init(frame: .zero, collectionViewLayout: layout)

    delegate = self
    dataSource = self

    showsVerticalScrollIndicator = false
    showsHorizontalScrollIndicator = false

    register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "dateCell")
    register(NoDateViewCell.self, forCellWithReuseIdentifier: "noDateCell")

    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false

    backgroundColor = .clear
  }
}

extension DateCollection: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return table.data.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let section = indexPath.row

    guard let date = table.data[section].0 else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noDateCell", for: indexPath) as! NoDateViewCell
      cell.value.text = "Другое"
      cell.backgroundColor = (indexPath.item == table.selectedDateIndex) ? UIColor.clear : UIColor.listRow
      cell.layer.borderColor = (indexPath.item == table.selectedDateIndex) ? UIColor.white.cgColor : UIColor.clear.cgColor

      return cell
    }

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCollectionViewCell
    let calendarDate = date.toString([.day, .month])

    cell.dayValue.text = calendarDate[.day]
    cell.monthValue.text = calendarDate[.month]

    cell.backgroundColor = (indexPath.item == table.selectedDateIndex) ? UIColor.clear : UIColor.listRow
    cell.layer.borderColor = (indexPath.item == table.selectedDateIndex) ? UIColor.white.cgColor : UIColor.clear.cgColor

    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    table.selectedDateIndex = indexPath.item
    table.scrollToRow(at: IndexPath(row: 0, section: table.selectedDateIndex), at: .top, animated: true)

    collectionView.reloadData()
  }
}

extension DateCollection: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 112, height: 82)
  }
}
