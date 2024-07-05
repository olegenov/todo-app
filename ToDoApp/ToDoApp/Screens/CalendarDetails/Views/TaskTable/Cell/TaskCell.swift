//
//  TskCell.swift
//  ToDoApp
//

import UIKit

class TaskCell: UITableViewCell {
  var crossedOut: Bool = false
  
  private var rightSwipeAction: (() -> Void)?
  private var leftSwipeAction: (() -> Void)?
  
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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    completeCrossOut(text: self.textLabel?.attributedText?.string ?? "")
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
        value: UIColor.textColor,
        range: NSMakeRange(0, attributeString.length)
      )
    }
    
    textLabel?.attributedText = attributeString
  }
}
