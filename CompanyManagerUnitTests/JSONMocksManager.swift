//
//    JsonMocksManager.swift
//    CompanyManagerUnitTests
//
//    Created by Kamil on 01/03/2019.
//    Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import Unicorns

final class JSONMocksManager {
  
  // MARK: - Initialization
  
  private init() {}
  
  // MARK: - Enums
  
  enum JSONs: String {
    case token
    case success
    case error
  }
  
  static func json(for type: JSONs) -> String {
    if let url = Bundle.main.url(forResource: "jsonMocks", withExtension: "json") {
      do {
        let data = try Data(contentsOf: url)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? JSON
        if let value = jsonResult?[type.rawValue],
          let decodedValue = try? JSONSerialization.data(withJSONObject: value, options: []) {
          return String(data: decodedValue, encoding: .utf8) ?? ""
        }
        return ""
      } catch {
        // handle error
        return ""
      }
    } else {
      fatalError("Missing jsonMocks file")
    }
  }
  
}
