//
//  TskCell.swift
//  ToDoApp
//

import UIKit

class TaskCell: UITableViewCell {
  var crossedOut: Bool = false
  
  private var rightSwipeAction: (() -> Void)?
  private var leftSwipeAction: (() -> Void)?
  private let categoryCircle = UIView()
  private var categoryColor = UIColor.clear
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureCategoryCircle()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureCategoryCircle()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    completeCrossOut(text: self.textLabel?.attributedText?.string ?? "")
    categoryCircle.backgroundColor = .clear
  }
  
  func configureCategoryCircle() {
    categoryCircle.layer.cornerRadius = 10
    categoryCircle.translatesAutoresizingMaskIntoConstraints = false
    categoryCircle.backgroundColor = categoryColor
    
    contentView.addSubview(categoryCircle)
    
    NSLayoutConstraint.activate([
      categoryCircle.heightAnchor.constraint(equalToConstant: 20),
      categoryCircle.widthAnchor.constraint(equalToConstant: 20),
      categoryCircle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      categoryCircle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
  
  func setupSwipe(
    leftSipeAction: @escaping () -> Void,
    rightSwipeAction: @escaping () -> Void
  ) {
    self.leftSwipeAction = leftSipeAction
    self.rightSwipeAction = rightSwipeAction
    
    let rightSwipeRecognizer = UISwipeGestureRecognizer(
      target: self,
      action: #selector(rightSwiped)
    )
    
    rightSwipeRecognizer.direction = .right
    
    let leftSwipeRecognizer = UISwipeGestureRecognizer(
      target: self,
      action: #selector(leftSwiped)
    )
    
    leftSwipeRecognizer.direction = .left
    
    self.addGestureRecognizer(rightSwipeRecognizer)
    self.addGestureRecognizer(leftSwipeRecognizer)
  }
  
  @objc private func rightSwiped() {
    rightSwipeAction?()
  }
  
  @objc private func leftSwiped() {
    leftSwipeAction?()
  }
  
  func completeCrossOut(text: String) {
    let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
    
    if crossedOut {
      attributeString.addAttribute(
        .strikethroughStyle,
        value: 1,
        range: NSMakeRange(0, attributeString.length)
      )
      attributeString.addAttribute(
        .foregroundColor,
        value: UIColor.gray,
        range: NSMakeRange(0, attributeString.length)
      )
    } else {
      attributeString.removeAttribute(
        .strikethroughStyle,
        range: NSMakeRange(0, attributeString.length)
      )
      attributeString.addAttribute(
        .foregroundColor,
        value: UIColor.textColor ?? UIColor.clear,
        range: NSMakeRange(0, attributeString.length)
      )
    }
    
    textLabel?.attributedText = attributeString
  }
  
  func setCategoryColor(_ color: UIColor) {
    categoryColor = color
    categoryCircle.backgroundColor = categoryColor
  }
}
