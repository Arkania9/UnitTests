//
//	ForgotPasswordInteractor.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit

protocol ForgotPasswordBusinessLogic {
    func validateTextField(request: ForgotPassword.Validate.Request)
    func sendPassword(request: ForgotPassword.Request)
}

protocol ForgotPasswordDataStore {}

class ForgotPasswordInteractor: ForgotPasswordBusinessLogic, ForgotPasswordDataStore {
    
    // MARK: - Properties
    
    var presenter: ForgotPasswordPresentationLogic?
    var worker: ForgotPasswordWorker = ForgotPasswordWorker()
    private let validationHelper = Validation(configuration: Validation.Configuration(fields: [.email]))
    
    // MARK: - Business Logic
    
    func validateTextField(request: ForgotPassword.Validate.Request) {
        guard let textFieldType = request.textFieldType else {
            print("Cannot validate field with no type")
            return
        }
        let validationResponse = validationHelper.validate(text: request.text, as: textFieldType)
        let response = ForgotPassword.Validate.Response(validationResponse: validationResponse,
                                                        textFieldType: textFieldType)
        presenter?.presentValidation(response: response)
    }
    
    func sendPassword(request: ForgotPassword.Request) {
        var areAllFieldsValid: Bool {
            return validationHelper.configuration.isValid()
        }
        if !areAllFieldsValid {
            validationHelper.validate(text: request.email, as: .email)
        }
        if validationHelper.configuration.isValid() {
            let sendRequest = ForgotPasswordWorker.SendRequest(email: request.email!)
            worker.send(request: sendRequest, onSuccess: { [weak self] in
                self?.presenter?.presentForgotPasswordSuccess()
                }, onError: { [weak self] error in
                    guard let `self` = self else { return }
                    let response = ForgotPassword.Response(error: error)
                    self.presenter?.presentForgotPasswordError(response: response)
            })
        } else {
            if let first = validationHelper.configuration.fieldsValidationStatus.first(where: {!$0.value}) {
                let error = AppError(description: "please_fill_field".localized + first.key.rawValue.lowercased())
                let response = ForgotPassword.Response(error: error)
                presenter?.presentForgotPasswordError(response: response)
            }
        }
    }
    
}
