//
//  Token.swift
//  CompanyManagerUnitTests
//
//  Created by Kamil on 01/03/2019.
//  Copyright © 2019 Kamil Zając. All rights reserved.
//

import Foundation

struct Token: Codable {
    let userId: UUID
    let value: String
    let expirationDate: Date
    
    enum CodingKeys: String, CodingKey {
        case userId
        case value = "token"
        case expirationDate = "expiresAt"
    }
}

