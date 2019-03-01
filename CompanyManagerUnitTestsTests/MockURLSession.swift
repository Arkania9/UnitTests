//
//    MockURLSession.swift
//    CompanyManagerUnitTests
//
//    Created by Kamil on 01/03/2019.
//    Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit
import Unicorns

class MockURLSession: URLSessionProtocol {
  
  // MARK: - Properties
  
  var dataTask = MockURLSessionDataTask()
  private (set) var expectedJSON: String
  private (set) var expectedStatusCode: Int
  
  // MARK: - Initializationz
  
  init(expectedJSON: String, expectedStatusCode: Int = 200) {
    self.expectedJSON = expectedJSON
    self.expectedStatusCode = expectedStatusCode
  }
  
  // MARK: - Functions
  
  func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
    let response = HTTPURLResponse(url: url, statusCode: expectedStatusCode, httpVersion: nil, headerFields: nil)
    completionHandler(expectedJSON.data(using: .utf8), response, nil)
    return dataTask
  }
  
  func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
    guard let url = request.url else {
      return dataTask
    }
    let response = HTTPURLResponse(url: url, statusCode: expectedStatusCode, httpVersion: nil, headerFields: nil)
    completionHandler(expectedJSON.data(using: .utf8), response, nil)
    return dataTask
  }
  
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
  
  private (set) var resumeWasCalled = false
  
  func resume() {
    resumeWasCalled = true
  }
  
}
