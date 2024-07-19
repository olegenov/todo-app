//
//  TokenManager.swift
//  ToDoApp
//

import Foundation

class TokenManager {
  static let shared = TokenManager()

  private let service = "com.yandex.ToDoApp"
  private let account = "userToken"

  func save(token: String) -> Bool {
    guard let data = token.data(using: .utf8) else {
      return false
    }

    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecValueData as String: data
    ]

    SecItemDelete(query as CFDictionary)

    let status = SecItemAdd(query as CFDictionary, nil)
    return status == errSecSuccess
  }

  func retrieve() -> String? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecReturnData as String: kCFBooleanTrue ?? "",
      kSecMatchLimit as String: kSecMatchLimitOne
    ]

    var dataTypeRef: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

    guard status == errSecSuccess, let data = dataTypeRef as? Data else {
      return nil
    }

    return String(decoding: data, as: UTF8.self)
  }
}
