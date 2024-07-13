//
//  URLSessionTests.swift
//  ToDoAppTests
//

import XCTest
@testable import ToDoApp

final class URLSessionTests: XCTestCase {
  func testSuccessfulRequest() async throws {
    var testUrl = "https://www.apple.com/"

    let expectedResponse = HTTPURLResponse(
      url: URL(string: testUrl)!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil
    )

    let session = URLSession.shared
    let urlRequest = URLRequest(url: URL(string: testUrl)!)


    let result = try await session.dataTask(for: urlRequest)

    XCTAssertEqual(result.1.url, expectedResponse?.url)
    XCTAssertEqual((result.1 as? HTTPURLResponse)?.statusCode, 200)
  }

  func testRequestWithError() async {
    var testUrl = "https://somethingDoesNotExist.com"

    let expectedErrorCode = -1003
    let session = URLSession.shared

    let urlRequest = URLRequest(url: URL(string: testUrl)!)

    do {
      _ = try await session.dataTask(for: urlRequest)
      XCTFail("Expected error to be thrown")
    } catch {
      if let error = error as? URLError {
        XCTAssertEqual(error.code.rawValue, expectedErrorCode)
      }
    }
  }

  func testCancelledTask() async {
    let session = URLSession.shared

    let urlRequest = URLRequest(url: URL(string: "https://apple.com")!)

    let task = Task {
      try await session.dataTask(for: urlRequest)
    }

    task.cancel()

    do {
      _ = try await task.value
      XCTFail("Expected task to be cancelled")
    } catch {
      XCTAssertTrue((error as? CancellationError) != nil)
    }
  }
}
