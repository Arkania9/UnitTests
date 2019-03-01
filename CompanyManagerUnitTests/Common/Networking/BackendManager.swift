//
//    BackendManager.swift
//    CompanyManagerUnitTests
//
//    Created by Kamil on 01/03/2019.
//    Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import Foundation
import Unicorns

public struct BackendManager {
    
    static let basic = URL(string: "https://companymanager.tk/")!
    
    public enum Endpoint: String, Endpointable {
        case login
        case register
        case forgotPassword
        case companies
        case projects
        case users
        case userInvite
        case tasks
        case saveProject
        case saveCompany
    }
    
    struct LoginRequest: EndpointRequest {
        typealias ResponseType = Token
        let email: String
        let password: String
        var data: EndpointData {
            let basicAuth = "\(email):\(password)".data(using: .utf8)?.base64EncodedString() ?? ""
            return EndpointData(Endpoint.login, method: .post, headers: ["Authorization": "Basic \(basicAuth)"])
        }
    }
    
    struct RegisterRequest: EndpointRequest {
        typealias ResponseType = Token
        let firstName: String
        let lastName: String
        let email: String
        let password: String
        let confirmPassword: String
        let referalCode: String?
        var data: EndpointData {
            return EndpointData(Endpoint.register, method: .post, parameters: ["firstName": firstName,
                                                                               "lastName": lastName,
                                                                               "email": email,
                                                                               "password": password,
                                                                               "verifyPassword": confirmPassword,
                                                                               "referalCode": referalCode as Any])
        }
    }
    
    struct ForgotPasswordRequest: EndpointRequest {
        typealias ResponseType = SuccessResponse
        let email: String
        var data: EndpointData {
            return EndpointData(Endpoint.forgotPassword, method: .post, parameters: ["email": email])
        }
    }
}
extension BackendManager {
    
    private static func autorizationHeader() -> [String: String] {
        guard let token = try? KeychainService.shared.retrive(item: .userAccessToken) else { return [:] }
        return ["Authorization": "Bearer \(token)"]
    }
    
    struct SuccessResponse: Codable {
        var isSuccess: Bool
    }
    
}
