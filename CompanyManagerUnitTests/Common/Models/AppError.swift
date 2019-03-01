//
//  AppError.swift
//  CompanyManagerUnitTests
//
//  Created by Kamil on 01/03/2019.
//  Copyright © 2019 Kamil Zając. All rights reserved.
//

import Foundation
import Unicorns

struct AppError: Error, LocalizedError {
    var code: Int
    var localizedDescription: String
    
    init(from networkError: NetworkingError) {
        self.code = networkError.code
        self.localizedDescription = networkError.description
    }
    
    init(code: Int, description: String) {
        self.code = code
        self.localizedDescription = description.localized
    }
    
    init(description: String) {
        self.code = 0
        self.localizedDescription = description.localized
    }
    
    init(error: Error) {
        if let networkingError = error as? NetworkingError {
            self.code = networkingError.code
            self.localizedDescription = networkingError.description
        } else if let appError = error as? AppError {
            self.code = appError.code
            self.localizedDescription = appError.localizedDescription
        } else {
            self.code = 0
            self.localizedDescription = error.localizedDescription
        }
    }
    
}

