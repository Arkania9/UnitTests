//
//	RegisterViewController.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit
import Unicorns

protocol RegisterDisplayLogic: class {
    func displayImagePickerClosed()
    func displayUserAvatar(viewModel: Register.UserAvatar.ViewModel)
    func displayImagePicker(viewModel: Register.ImagePicker.ViewModel)
    func displayValidationError(viewModel: Register.Validate.ViewModel)
    func displayValidationSuccess(viewModel: Register.Validate.ViewModel)
    func displayRegisterSuccess()
    func displayRegisterError(viewModel: Register.RegisterUser.ViewModel)
}

class RegisterViewController: UIViewController, RegisterDisplayLogic, ErrorAlertRouter, ImageCropRouter {
    
    // MARK: - Outlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: FloatTextField!
    @IBOutlet weak var lastNameTextField: FloatTextField!
    @IBOutlet weak var emailTextField: FloatTextField!
    @IBOutlet weak var passwordTextField: FloatTextField!
    @IBOutlet weak var repeatPasswordTextField: FloatTextField!
    @IBOutlet weak var referalCodeTextField: FloatTextField!
    @IBOutlet weak var registerButton: RoundedButton!
    
    // MARK: - Properties
    
    var interactor: RegisterBusinessLogic?
    var router: (NSObjectProtocol & RegisterRoutingLogic & RegisterDataPassing)?
    
    // MARK: - Initialization
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        let viewController = self
        let interactor = RegisterInteractor()
        let presenter = RegisterPresenter()
        let router = RegisterRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: - Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackArrow()
        setupTitle(with: "register")
    }
    
    // MARK: - Actions
    
    @IBAction func avatarTapAction(_ sender: UITapGestureRecognizer) {
        interactor?.selectUserAvatar()
    }
    
    @IBAction func registerButtonAction(_ sender: RoundedButton) {
        let request = Register.RegisterUser.Request(firstName: firstNameTextField.text,
                                                    lastName: lastNameTextField.text,
                                                    email: emailTextField.text,
                                                    password: passwordTextField.text,
                                                    confirmPassword: repeatPasswordTextField.text,
                                                    referalCode: referalCodeTextField.text)
        interactor?.registerUser(request: request)
    }
    
    // MARK: - Display Logic
    
    func displayImagePickerClosed() {
        dismiss(animated: true, completion: nil)
    }
    
    func displayUserAvatar(viewModel: Register.UserAvatar.ViewModel) {
        let cropperViewModel = ImageCropViewController.ViewModel(image: viewModel.image, rectType: .round, delegate: self)
        routeToCropImage(viewModel: cropperViewModel)
    }
    
    func displayImagePicker(viewModel: Register.ImagePicker.ViewModel) {
        present(viewModel.picker, animated: true, completion: nil)
    }
    
    func displayValidationError(viewModel: Register.Validate.ViewModel) {
        textField(for: viewModel.textFieldType)?.failure(error: viewModel.message)
    }
    
    func displayValidationSuccess(viewModel: Register.Validate.ViewModel) {
        textField(for: viewModel.textFieldType)?.success()
    }
    
    func displayRegisterSuccess() {
        registerButton.handleResponse(with: .success) { 
            print("Register success")
        }
    }
    
    func displayRegisterError(viewModel: Register.RegisterUser.ViewModel) {
        let errorViewModel = ErrorAlertViewModel(from: viewModel) {
            self.registerButton.handleResponse(with: .failure)
        }
        showErrorAlert(with: errorViewModel)
    }
    
    // MARK: - Functions
    
    private func textField(for type: Validation.FieldType) -> FloatTextField? {
        var textField: FloatTextField?
        switch type {
        case .firstName:
            textField = firstNameTextField
        case .lastName:
            textField = lastNameTextField
        case .email:
            textField = emailTextField
        case .password:
            textField = passwordTextField
        case .confirmPassword:
            textField = repeatPasswordTextField
        default: break
        }
        return textField
    }
    
    private func type(for textField: FloatTextField) -> Validation.FieldType? {
        var types: Validation.FieldType?
        switch textField {
        case firstNameTextField:
            types = .firstName
        case lastNameTextField:
            types = .lastName
        case emailTextField:
            types = .email
        case passwordTextField:
            types = .password
        case repeatPasswordTextField:
            types = .confirmPassword
        default: break
        }
        return types
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        if let floatTextField = textField as? FloatTextField {
            let request = Register.Validate.Request(text: floatTextField.text, textFieldType: type(for: floatTextField))
            interactor?.validateTextField(request: request)
        }
    }
    
}

extension RegisterViewController: ImageCropDelegate {
    
    func didCropImage(to image: UIImage?) {
        avatarImageView.image = image
    }
    
    func didCancelCrop(image: UIImage?) {
        avatarImageView.image = image
    }
    
}
