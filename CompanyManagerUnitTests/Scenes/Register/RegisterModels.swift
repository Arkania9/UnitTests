//
//	RegisterModels.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit

enum Register {
    
    enum UserAvatar {
        
        struct Response {
            var image: UIImage
        }
        struct ViewModel {
            var image: UIImage
        }
        
    }
    
    enum ImagePicker {
        
        struct Response {
            var picker: UIImagePickerController
        }
        struct ViewModel {
            var picker: UIImagePickerController
        }
        
    }
    
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
    
    enum RegisterUser {
        
        struct Request {
            var firstName: String?
            var lastName: String?
            var email: String?
            var password: String?
            var confirmPassword: String?
            var referalCode: String?
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
    
}

