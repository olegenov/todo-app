//
//  DefaultNetworkingService.swift
//  ToDoApp
//

import Foundation

class DefaultNetworkingService: NetworkingService {
  private let urlSession: URLSession
  private let baseURL: URL

  init(urlSession: URLSession = .shared, baseURL: URL) {
    self.urlSession = urlSession
    self.baseURL = baseURL
  }

  func get<T: Codable>(
    path: String,
    completion: @escaping (Result<T, Error>) -> Void
  ) async {
    let url = baseURL.appendingPathComponent(path)
    var request = URLRequest(url: url)

    request.httpMethod = "GET"

    await performRequest(request, completion: completion)
  }

  func post<T: Request, U: Codable> (
    path: String,
    requestObject: T,
    completion: @escaping (Result<U, Error>) -> Void
  ) async {
    let url = baseURL.appendingPathComponent(path)
    var request = URLRequest(url: url)

    request.httpMethod = "POST"
    request.setValue(
      "\(requestObject.revision)",
      forHTTPHeaderField: "X-Last-Known-Revision"
    )

    do {
      request.httpBody = try JSONEncoder().encode(requestObject)
    } catch {
      if let error = error as? URLError {
        Logger.shared.logError(error.localizedDescription)
      }

      completion(.failure(error))
    }

    await performRequest(request, completion: completion)
  }

  func delete<T: Request, U: Codable>(
    path: String,
    requestObject: T,
    completion: @escaping (Result<U, Error>) -> Void
  ) async {
    let url = baseURL.appendingPathComponent(path)
    var request = URLRequest(url: url)

    request.httpMethod = "DELETE"
    request.setValue(
      "\(requestObject.revision)",
      forHTTPHeaderField: "X-Last-Known-Revision"
    )

    await performRequest(request, completion: completion)
  }

  func put<T: Request, U: Codable>(
    path: String,
    requestObject: T,
    completion: @escaping (Result<U, Error>) -> Void
  ) async {
    let url = baseURL.appendingPathComponent(path)
    var request = URLRequest(url: url)

    request.httpMethod = "PUT"
    request.setValue(
      "\(requestObject.revision)",
      forHTTPHeaderField: "X-Last-Known-Revision"
    )

    do {
      request.httpBody = try JSONEncoder().encode(requestObject)
    } catch {
      if let error = error as? URLError {
        Logger.shared.logError(error.localizedDescription)
      }

      completion(.failure(error))
    }

    await performRequest(request, completion: completion)
  }

  func patch<T: Request, U: Codable>(
    path: String,
    requestObject: T,
    completion: @escaping (Result<U, Error>) -> Void
  ) async {
    let url = baseURL.appendingPathComponent(path)
    var request = URLRequest(url: url)

    request.httpMethod = "PATCH"
    request.setValue(
      "\(requestObject.revision)",
      forHTTPHeaderField: "X-Last-Known-Revision"
    )

    do {
      request.httpBody = try JSONEncoder().encode(requestObject)
    } catch {
      if let error = error as? URLError {
        Logger.shared.logError(error.localizedDescription)
      }

      completion(.failure(error))
    }

    await performRequest(request, completion: completion)
  }

  private func performRequest<T: Codable>(
    _ request: URLRequest,
    completion: @escaping (Result<T, Error>) -> Void
  ) async {
    var requestToPerform = request

    requestToPerform.setValue(
      "Bearer Elured",
      forHTTPHeaderField: "Authorization"
    )

    var currentAttempt = 1
    let maxRetries = 5

    do {
      let (data, _) = try await urlSession.dataTask(for: requestToPerform)

      let decodedData = try JSONDecoder().decode(T.self, from: data)

      completion(.success(decodedData))
    } catch {
      if let error = error as? URLError {
        Logger.shared.logError(error.localizedDescription)
      }

      while currentAttempt < maxRetries {
        guard let delay = Delayer.countDelay(attempt: currentAttempt) else {
          completion(.failure(error))
          return
        }

        Logger.shared.logInfo("Current delay: \(delay)")

        currentAttempt += 1

        do {
          try await Task.sleep(nanoseconds: delay * 1000000000)

          let (data, _) = try await urlSession.dataTask(for: requestToPerform)

          let decodedData = try JSONDecoder().decode(T.self, from: data)

          completion(.success(decodedData))
          break
        } catch {
          Logger.shared.logError("Error delaying the request")
        }
      }

      completion(.failure(error))
    }
  }
}
