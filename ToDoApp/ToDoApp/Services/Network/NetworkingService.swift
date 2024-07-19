//
//  NetworkingService.swift
//  ToDoApp
//

import Foundation

protocol NetworkingService {
  func get<T: Codable>(path: String, completion: @escaping (Result<T, Error>) -> Void) async
  func post<T: Request, U: Codable>(path: String, requestObject: T, completion: @escaping (Result<U, Error>) -> Void) async
  func delete<T: Request, U: Codable>(path: String, requestObject: T, completion: @escaping (Result<U, Error>) -> Void) async
  func put<T: Request, U: Codable>(path: String, requestObject: T, completion: @escaping (Result<U, Error>) -> Void) async
  func patch<T: Request, U: Codable>(path: String, requestObject: T, completion: @escaping (Result<U, Error>) -> Void) async
}
