//
//	RegisterInteractor.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit
import Unicorns

protocol RegisterBusinessLogic {
    func selectUserAvatar()
    func validateTextField(request: Register.Validate.Request)
    func registerUser(request: Register.RegisterUser.Request)
}

protocol RegisterDataStore {}

class RegisterInteractor: NSObject, RegisterBusinessLogic, RegisterDataStore {
    
    // MARK: - Properties
    
    var presenter: RegisterPresentationLogic?
    var worker: RegisterWorker = RegisterWorker()
    private var imagePicker = UIImagePickerController()
    private var validationHelper: Validation!
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        imagePicker.delegate = self
        validationHelper = Validation(configuration: Validation.Configuration(fields: [.firstName,
                                                                                       .lastName,
                                                                                       .email,
                                                                                       .password,
                                                                                       .confirmPassword]))
    }
    
    // MARK: - Business Logic
    
    func selectUserAvatar() {
        let response = Register.ImagePicker.Response(picker: imagePicker)
        presenter?.presentImagePicker(response: response)
    }
    
    func validateTextField(request: Register.Validate.Request) {
        guard let textFieldType = request.textFieldType else {
            print("Cannot validate field with no type")
            return
        }
        let validationResponse = validationHelper.validate(text: request.text, as: textFieldType)
        let response = Register.Validate.Response(validationResponse: validationResponse, textFieldType: textFieldType)
        presenter?.presentValidation(response: response)
    }
    
    func registerUser(request: Register.RegisterUser.Request) {
        var areAllFieldsValid: Bool {
            return validationHelper.configuration.isValid()
        }
        if !areAllFieldsValid {
            validationHelper.validate(text: request.firstName, as: .firstName)
            validationHelper.validate(text: request.lastName, as: .lastName)
            validationHelper.validate(text: request.email, as: .email)
            validationHelper.validate(text: request.password, as: .password)
            validationHelper.validate(text: request.confirmPassword, as: .confirmPassword)
        }
        if validationHelper.configuration.isValid() {
            let registerRequest = RegisterWorker.RegisterReqeust(firstName: request.firstName!,
                                                                 lastName: request.lastName!,
                                                                 email: request.email!,
                                                                 password: request.password!,
                                                                 confirmPassword: request.confirmPassword!,
                                                                 referalCode: request.referalCode)
            worker.register(request: registerRequest, onSuccess: { [weak self] token in
                guard let `self` = self else { return }
                self.saveAuthorization(token: token.value)
                self.presenter?.presentRegisterSuccess()
                }, onError: { [weak self] error in
                    guard let `self` = self else { return }
                    let response = Register.RegisterUser.Response(error: error)
                    self.presenter?.presentRegisterError(response: response)
            })
        } else {
            if let first = validationHelper.configuration.fieldsValidationStatus.first(where: {!$0.value}) {
                let error = AppError(description: "please_fill_field".localized + first.key.rawValue.lowercased())
                let response = Register.RegisterUser.Response(error: error)
                presenter?.presentRegisterError(response: response)
            }
        }
    }
    
    // MARK: - Functions
    
    private func saveAuthorization(token: String) {
        do {
            try KeychainService.shared.save(value: token, as: .userAccessToken)
        } catch {
            Log.e(error)
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension RegisterInteractor: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presenter?.presentImagePickerClosed()
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            let response = Register.UserAvatar.Response(image: pickedImage)
            presenter?.presentImagePickerClosed()
            presenter?.presentUserAvatar(response: response)
        }
    }
    
}
