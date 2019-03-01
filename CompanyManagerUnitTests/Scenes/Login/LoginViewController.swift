//
//	LoginViewController.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit
import Unicorns

protocol LoginDisplayLogic: class {
    func displayValidationError(viewModel: Login.Validate.ViewModel)
    func displayValidationSuccess(viewModel: Login.Validate.ViewModel)
    func displayLoginSuccess()
    func displayLoginError(viewModel: Login.LoginUser.ViewModel)
}

class LoginViewController: UIViewController, LoginDisplayLogic, ErrorAlertRouter {
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: FloatTextField!
    @IBOutlet weak var passwordTextField: FloatTextField!
    @IBOutlet weak var loginButton: RoundedButton!
    
    // MARK: - Properties
    
    var interactor: LoginBusinessLogic?
    var router: (NSObjectProtocol & LoginRoutingLogic & LoginDataPassing)?
    
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
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        let router = LoginRouter()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar()
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonAction(_ sender: RoundedButton) {
        validateAllFields()
        let request = Login.LoginUser.Request(email: emailTextField.text, password: passwordTextField.text)
        interactor?.loginUser(request: request)
    }
    
    // MARK: - Display Logic
    
    func displayValidationError(viewModel: Login.Validate.ViewModel) {
//        textField(for: viewModel.textFieldType)?.failure(error: viewModel.message)
    }
    
    func displayValidationSuccess(viewModel: Login.Validate.ViewModel) {
//        textField(for: viewModel.textFieldType)?.success()
    }
    
    func displayLoginSuccess() {
        loginButton.handleResponse(with: .success) { [weak self] in
            self?.router?.routeToHome(segue: nil)
        }
    }
    
    func displayLoginError(viewModel: Login.LoginUser.ViewModel) {
        let errorViewModel = ErrorAlertViewModel(from: viewModel) {
            self.loginButton.handleResponse(with: .failure)
        }
        showErrorAlert(with: errorViewModel)
    }
    
    // MARK: - Functions
    
    private func textField(for type: Validation.FieldType) -> FloatTextField? {
        var textField: FloatTextField?
        switch type {
        case .email:
            textField = emailTextField
        case .password:
            textField = passwordTextField
        default: break
        }
        return textField
    }
    
    private func type(for textField: FloatTextField) -> Validation.FieldType? {
        var types: Validation.FieldType?
        switch textField {
        case emailTextField:
            types = .email
        case passwordTextField:
            types = .password
        default: break
        }
        return types
    }
    
    private func validateAllFields() {
        let allTextFields = [emailTextField, passwordTextField]
        allTextFields.forEach({ [weak self] textField in
            guard let textField = textField else { return }
            let request = Login.Validate.Request(text: textField.text, textFieldType: type(for: textField))
            self?.interactor?.validateTextField(request: request)
        })
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        if let floatTextField = textField as? FloatTextField {
            let request = Login.Validate.Request(text: floatTextField.text, textFieldType: type(for: floatTextField))
            interactor?.validateTextField(request: request)
        }
    }
    
}
