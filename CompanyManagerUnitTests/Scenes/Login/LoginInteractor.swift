//
//	LoginInteractor.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit
import Unicorns

protocol LoginBusinessLogic {
    func validateTextField(request: Login.Validate.Request)
    func loginUser(request: Login.LoginUser.Request)
}

protocol LoginDataStore {}

class LoginInteractor: LoginBusinessLogic, LoginDataStore {
    
    // MARK: - Properties
    
    var presenter: LoginPresentationLogic?
    private var worker = LoginWorker()
    private var validationHelper: Validation!
    
    // MARK: - Initialization
    
    init() {
        validationHelper = Validation(configuration: Validation.Configuration(fields: [.email, .password]))
    }
    
    // MARK: - Business Logic
    
    func validateTextField(request: Login.Validate.Request) {
        guard let textFieldType = request.textFieldType else {
            print("Cannot validate field with no type")
            return
        }
        
        let validationResponse = validationHelper.validate(text: request.text, as: textFieldType)
        let response = Login.Validate.Response(validationResponse: validationResponse, textFieldType: textFieldType)
        presenter?.presentValidation(response: response)
        
    }
    
    func loginUser(request: Login.LoginUser.Request) {
        var areAllFieldsValid: Bool {
            return validationHelper.configuration.isValid()
        }
        if !areAllFieldsValid {
            validationHelper.validate(text: request.email, as: .email)
            validationHelper.validate(text: request.password, as: .password)
        }
        if areAllFieldsValid, let email = request.email, let password = request.password {
            let loginRequest = LoginWorker.LoginRequest(email: email, password: password)
            worker.login(request: loginRequest, onSuccess: { [weak self] token in
                guard let `self` = self else { return }
                self.saveAuthorization(token: token.value)
                self.presenter?.presentLoginSuccess()
                }, onError: { [weak self] error in
                    guard let `self` = self else { return }
                    let response = Login.LoginUser.Response(error: error)
                    self.presenter?.presentLoginError(response: response)
            })
        } else {
            if let first = validationHelper.configuration.fieldsValidationStatus.first(where: {!$0.value}) {
                let error = AppError(description: "please_fill_field".localized + first.key.rawValue.lowercased())
                let response = Login.LoginUser.Response(error: error)
                presenter?.presentLoginError(response: response)
            }
        }
    }
    
    // MARK: - Functions
    
    private func saveAuthorization(token: String) {
        Log.s("New token: \(token)")
        do {
            try KeychainService.shared.save(value: token, as: .userAccessToken)
        } catch {
            Log.e(error)
        }
    }
    
}
