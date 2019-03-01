//
//  Validation.swift
//  CompanyManagerUnitTests
//
//  Created by Kamil on 01/03/2019.
//  Copyright © 2019 Kamil Zając. All rights reserved.
//

import Foundation
struct ValidationResponse {
    let validated: Bool
    let message: String?
}

class Validation {
    
    struct ValidationStructure {
        var minChars: Int
        var maxChars: Int
        var regexp: String?
        var regexpError: String?
    }
    
    struct Configuration {
        var fields: [FieldType]
        internal var fieldsValidationStatus: [FieldType: Bool] = [:]
        
        init(fields: [FieldType]) {
            self.fields = fields
            fields.forEach({ fieldsValidationStatus[$0] = false })
        }
        
        func isValid() -> Bool {
            return fieldsValidationStatus.first(where: {!$0.value})?.value ?? true
        }
    }
    
    // MARK: - Enums
    
    enum FieldType: String {
        case email = "Email"
        case firstName = "First name"
        case lastName = "Last name"
        case password = "Password"
        case confirmPassword = "Confirm password"
        case phone = "Phone"
        case birthdate = "Birthdate"
        case projectName = "Project name"
        case projectDescription = "Project description"
        case companyName = "Company name"
        case companyDescription = "Company description"
        
        func requirements() -> ValidationStructure {
            var structure: ValidationStructure
            switch self {
            case .email:
                structure = ValidationStructure(minChars: 2, maxChars: 64,
                                                regexp: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}",
                                                regexpError: "only_leters_and_numbers".localized)
            case .password, .confirmPassword:
                structure = ValidationStructure(minChars: 5, maxChars: 20, regexp: "^[a-zA-Z0-9]*$",
                                                regexpError: "only_leters_and_numbers".localized)
            case .phone:
                structure = ValidationStructure(minChars: 5, maxChars: 10, regexp: "^[0-9]*$",
                                                regexpError: "only_numbers".localized)
            case .birthdate:
                structure = ValidationStructure(minChars: 8, maxChars: 10, regexp: "^[0-9-]*$",
                                                regexpError: "Only numbers and '-'")
            case .firstName, .lastName:
                structure = ValidationStructure(minChars: 2, maxChars: 20, regexp: "^[a-zA-Z]*$",
                                                regexpError: "only_letters".localized)
            case .projectName, .companyName:
                structure = ValidationStructure(minChars: 2, maxChars: 20, regexp: "^[a-zA-Z0-9\\s]*$",
                                                regexpError: "only_letters".localized)
            case .projectDescription, .companyDescription:
                structure = ValidationStructure(minChars: 0, maxChars: 300, regexp: "^[\\s\\S]*$",
                                                regexpError: "only_leters_and_numbers".localized)
            }
            return structure
        }
        
    }
    
    // MARK: - Properties
    
    private var _configuration: Configuration
    var configuration: Configuration {
        return _configuration
    }
    private var password: String = ""
    private var confirmPassword: String = ""
    
    // MARK: - Initialization
    
    init(configuration: Configuration) {
        self._configuration = configuration
    }
    
    // MARK: - Functions
    
    @discardableResult
    func validate(text: String?, as fieldType: FieldType) -> ValidationResponse {
        _configuration.fieldsValidationStatus[fieldType] = false
        guard let text = text else {
            return ValidationResponse(validated: false, message: "\("please_provide".localized) \(fieldType.rawValue)")
        }
        var message: String?
        let requirements = fieldType.requirements()
        if text.count < requirements.minChars {
            message = "\("min".localized) \(requirements.minChars) \("characters_required".localized)"
        } else if text.count > requirements.maxChars {
            message = "\("maximum_of".localized) \(requirements.maxChars) \("characters_reached".localized)"
        }
        guard let errorMessage = message else {
            let predicate = NSPredicate(format: "SELF MATCHES %@", requirements.regexp ?? "")
            let isValidated = predicate.evaluate(with: text)
            
            //Checking if password and confirm password are identiqual
            if fieldType == .password || fieldType == .confirmPassword {
                if fieldType == .password {
                    password = text
                } else {
                    confirmPassword = text
                }
                if !password.isEmpty && !confirmPassword.isEmpty && isValidated {
                    _configuration.fieldsValidationStatus[fieldType] = password == confirmPassword
                    return ValidationResponse(validated: password == confirmPassword,
                                              message: "password_confirm_password_should_equal".localized)
                }
            }
            _configuration.fieldsValidationStatus[fieldType] = isValidated
            return ValidationResponse(validated: isValidated, message: requirements.regexpError)
            
        }
        return ValidationResponse(validated: false, message: errorMessage)
    }
    
    func validate(text: String?, as fieldTypes: [FieldType]) -> ValidationResponse {
        var validated = false
        var errorMessage = ""
        fieldTypes.enumerated().forEach { (offset: Int, element: Validation.FieldType) in
            if self.is(text: text, ofType: element) {
                validated = true
                return
            }
            errorMessage += offset == 0 ? element.rawValue : " \("or".localized) \(element.rawValue)"
        }
        return ValidationResponse(validated: validated, message: "\("please_provide".localized) \(errorMessage)")
    }
    
    func `is`(text: String?, ofType fieldType: FieldType) -> Bool {
        guard let text = text else { return false }
        let requirements = fieldType.requirements()
        if text.count < requirements.minChars || text.count > requirements.maxChars {
            return false
        }
        return NSPredicate(format: "SELF MATCHES %@", requirements.regexp ?? "").evaluate(with: text)
    }
    
}

