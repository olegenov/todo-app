//
//  NoDateViewCell.swift
//  ToDoApp
//

import UIKit

class NoDateViewCell: UICollectionViewCell {
  var value = UILabel()
  
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
    value.translatesAutoresizingMaskIntoConstraints = false
    value.textAlignment = .center
    self.addSubview(value)
    
    NSLayoutConstraint.activate([
      value.centerXAnchor.constraint(equalTo: centerXAnchor),
      value.centerYAnchor.constraint(equalTo: centerYAnchor),
      value.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      value.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    ])
  }
}
