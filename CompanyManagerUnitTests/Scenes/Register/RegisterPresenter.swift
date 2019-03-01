//
//	RegisterPresenter.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit

protocol RegisterPresentationLogic {
    func presentImagePickerClosed()
    func presentUserAvatar(response: Register.UserAvatar.Response)
    func presentImagePicker(response: Register.ImagePicker.Response)
    func presentValidation(response: Register.Validate.Response)
    func presentRegisterSuccess()
    func presentRegisterError(response: Register.RegisterUser.Response)
}

class RegisterPresenter: RegisterPresentationLogic {
    
    // MARK: - Properties
    
    weak var viewController: RegisterDisplayLogic?
    
    // MARK: - Presentation Logic
    
    func presentImagePickerClosed() {
        viewController?.displayImagePickerClosed()
    }
    
    func presentUserAvatar(response: Register.UserAvatar.Response) {
        let viewModel = Register.UserAvatar.ViewModel(image: response.image)
        viewController?.displayUserAvatar(viewModel: viewModel)
    }
    
    func presentImagePicker(response: Register.ImagePicker.Response) {
        setupLibrary(picker: response.picker)
    }
    
    func presentValidation(response: Register.Validate.Response) {
        let viewModel = Register.Validate.ViewModel(textFieldType: response.textFieldType,
                                                    message: response.validationResponse.message ?? "")
        if response.validationResponse.validated {
            viewController?.displayValidationSuccess(viewModel: viewModel)
        } else {
            viewController?.displayValidationError(viewModel: viewModel)
        }
    }
    
    func presentRegisterSuccess() {
        viewController?.displayRegisterSuccess()
    }
    
    func presentRegisterError(response: Register.RegisterUser.Response) {
        let viewModel = Register.RegisterUser.ViewModel(title: "error".localized,
                                                        message: response.error.localizedDescription,
                                                        buttons: [ErrorAlertButton("ok".localized, nil)])
        viewController?.displayRegisterError(viewModel: viewModel)
    }
    
    // MARK: - Private Functions
    
    private func setupLibrary(picker: UIImagePickerController) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        let viewModel = Register.ImagePicker.ViewModel(picker: picker)
        viewController?.displayImagePicker(viewModel: viewModel)
    }
    
}
