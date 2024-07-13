//
//  DateCollectionViewCell.swift
//  ToDoApp
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
  var dayValue = UILabel()
  var monthValue = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configureUI() {
    configureLabels()

    layer.borderWidth = 2
    layer.cornerRadius = 16
  }

  private func configureLabels() {
    let stack = UIStackView()
    stack.alignment = .center
    stack.axis = .vertical
    stack.spacing = 4

    dayValue.translatesAutoresizingMaskIntoConstraints = false
    monthValue.translatesAutoresizingMaskIntoConstraints = false
    stack.translatesAutoresizingMaskIntoConstraints = false

    stack.addArrangedSubview(dayValue)
    stack.addArrangedSubview(monthValue)

    self.addSubview(stack)

    NSLayoutConstraint.activate([
      stack.centerXAnchor.constraint(equalTo: centerXAnchor),
      stack.centerYAnchor.constraint(equalTo: centerYAnchor),
      stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    ])
  }
}
