//
//	LoginModels.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit

enum Login {
    
    struct Validate {
        
        struct Request {
            var text: String?
            var textFieldType: Validation.FieldType?
        }
        struct Response {
            var validationResponse: ValidationResponse
            var textFieldType: Validation.FieldType
        }
        struct ViewModel {
            var textFieldType: Validation.FieldType
            var message: String
        }
        
    }
    
    enum LoginUser {
        
        struct Request {
            var email: String?
            var password: String?
        }
        struct Response {
            var error: AppError
        }
        struct ViewModel: ErrorProtocol {
            var title: String
            var message: String
            var buttons: [ErrorAlertButton]
        }
        
    }
    
    struct ViewModel: ErrorProtocol {
        var title: String
        var message: String
        var buttons: [ErrorAlertButton]
    }
    
}
