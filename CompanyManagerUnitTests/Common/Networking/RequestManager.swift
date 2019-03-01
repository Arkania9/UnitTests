//
//    RequestManager.swift
//    CompanyManagerUnitTests
//
//    Created by Kamil on 01/03/2019.
//    Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import Foundation
import Unicorns

public protocol Endpointable {
  var rawValue: String { get }
}
extension Endpointable {
  fileprivate var path: String {
    return BackendManager.basic.appendingPathComponent(rawValue).absoluteString
  }
}

public struct EndpointData {
  public let path: String
  public let method: Networking.NetworkMethod
  public let parameters: JSON?
  public let headers: Headers?
  
  public init (path: String, method: Networking.NetworkMethod, parameters: JSON? = nil, headers: Headers? = nil) {
    self.path = path
    self.method = method
    self.parameters = parameters
    self.headers = headers
  }
  
  public init (_ endpoint: Endpointable,
               method: Networking.NetworkMethod,
               parameters: JSON? = nil,
               headers: Headers? = nil) {
    self.path = endpoint.path
    self.method = method
    self.parameters = parameters
    self.headers = headers
  }
  
}

public protocol EndpointRequest {
  associatedtype ResponseType: Codable
  var data: EndpointData { get }
}

public extension EndpointRequest {
  
  func execute(with jsonDecoder: JSONDecoder = JSONDecoder(),
               onSuccess: @escaping (ResponseType) -> Void,
               onError: @escaping (Error) -> Void) {
    Networking.shared.request(with: data.path,
                              method: data.method,
                              parameters: data.parameters,
                              headers: data.headers,
                              onSuccess: { data in
      do {
        let result = try jsonDecoder.decode(ResponseType.self, from: data)
        DispatchQueue.main.async {
          onSuccess(result)
        }
      } catch let error {
        Log.e("Cannot decode data: \(String(describing: String(data: data, encoding: .utf8)))")
        Log.e(error.localizedDescription)
        DispatchQueue.main.async {
          onError(error)
        }
      }
    }, onError: { error in
      DispatchQueue.main.async {
        onError(error)
      }
    })
  }
  
}
