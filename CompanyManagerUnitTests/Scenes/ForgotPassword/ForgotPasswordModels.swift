//
//	ForgotPasswordModels.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit

enum ForgotPassword {
    
    enum Validate {
        
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
    
    struct Request {
        var email: String?
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
