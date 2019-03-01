//
//	LoginPresenter.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit

protocol LoginPresentationLogic {
    func presentValidation(response: Login.Validate.Response)
    func presentLoginSuccess()
    func presentLoginError(response: Login.LoginUser.Response)
}

class LoginPresenter: LoginPresentationLogic {
    
    // MARK: - Properties
    
    weak var viewController: LoginDisplayLogic?
    
    // MARK: - Presentation Logic
    
    func presentValidation(response: Login.Validate.Response) {
        let viewModel = Login.Validate.ViewModel(textFieldType: response.textFieldType,
                                                 message: response.validationResponse.message ?? "")
        if response.validationResponse.validated {
            viewController?.displayValidationSuccess(viewModel: viewModel)
        } else {
            viewController?.displayValidationError(viewModel: viewModel)
        }
    }
    
    func presentLoginSuccess() {
        viewController?.displayLoginSuccess()
    }
    
    func presentLoginError(response: Login.LoginUser.Response) {
        let viewModel = Login.LoginUser.ViewModel(title: "error".localized,
                                                  message: response.error.localizedDescription,
                                                  buttons: [ErrorAlertButton("ok".localized, nil)])
        viewController?.displayLoginError(viewModel: viewModel)
    }
    
}
