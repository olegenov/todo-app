//
//  URLSessionExtension.swift
//  ToDoApp
//

import Foundation

extension URLSession {
  func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
    try await withCheckedThrowingContinuation { continuation in
      let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        if let error = error {
          if error.localizedDescription == "cancelled" {
            continuation.resume(throwing: CancellationError())

            return
          }

          continuation.resume(throwing: error)
        } else if let data = data, let response = response {
          continuation.resume(returning: (data, response))
        } else {
          continuation.resume(throwing: URLError(.badServerResponse))
        }
      }

      task.resume()

      if Task.isCancelled {
        task.cancel()
      }
    }
  }
}
