//
//	ForgotPasswordPresenter.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit

protocol ForgotPasswordPresentationLogic {
    func presentValidation(response: ForgotPassword.Validate.Response)
    func presentForgotPasswordSuccess()
    func presentForgotPasswordError(response: ForgotPassword.Response)
}

class ForgotPasswordPresenter: ForgotPasswordPresentationLogic {
    
    // MARK: - Properties
    
    weak var viewController: ForgotPasswordDisplayLogic?
    
    // MARK: - Presentation Logic
    
    func presentValidation(response: ForgotPassword.Validate.Response) {
        let viewModel = ForgotPassword.Validate.ViewModel(textFieldType: response.textFieldType,
                                                          message: response.validationResponse.message ?? "")
        if response.validationResponse.validated {
            viewController?.displayValidationSuccess(viewModel: viewModel)
        } else {
            viewController?.displayValidationError(viewModel: viewModel)
        }
    }
    
    func presentForgotPasswordSuccess() {
        viewController?.displaySendSuccess()
    }
    
    func presentForgotPasswordError(response: ForgotPassword.Response) {
        let viewModel = ForgotPassword.ViewModel(title: "error".localized,
                                                 message: response.error.localizedDescription,
                                                 buttons: [ErrorAlertButton("ok".localized, nil)])
        viewController?.displaySendError(viewModel: viewModel)
    }
    
}
