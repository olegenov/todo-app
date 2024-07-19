//
//  Request.swift
//  ToDoApp
//

import Foundation

protocol Request: Codable {
  var revision: Int { get }
}
