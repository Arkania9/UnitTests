//
//	ForgotPasswordViewController.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import Unicorns

protocol ForgotPasswordDisplayLogic: class {
    func displaySendSuccess()
    func displaySendError(viewModel: ForgotPassword.ViewModel)
    func displayValidationError(viewModel: ForgotPassword.Validate.ViewModel)
    func displayValidationSuccess(viewModel: ForgotPassword.Validate.ViewModel)
}

class ForgotPasswordViewController: UIViewController, ForgotPasswordDisplayLogic, ErrorAlertRouter {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: CMFloatLabelTextField!
    @IBOutlet weak var sendButton: RoundedButton!
    
    // MARK: - Properties
    
    var interactor: ForgotPasswordBusinessLogic?
    var router: (NSObjectProtocol & ForgotPasswordRoutingLogic & ForgotPasswordDataPassing)?
    
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
        let interactor = ForgotPasswordInteractor()
        let presenter = ForgotPasswordPresenter()
        let router = ForgotPasswordRouter()
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
        setupTitle(with: "reset_password")
    }
    
    // MARK: - Actions
    
    @IBAction func sendButtonAction(_ sender: UIButton) {
        let request = ForgotPassword.Request(email: emailTextField.text)
        interactor?.sendPassword(request: request)
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Display Logic
    
    func displaySendSuccess() {
        let viewModel = ErrorAlertViewModel(title: "reset_password".localized,
                                            message: "reset_password.sended".localized,
                                            buttons: [ErrorAlertButton("ok".localized, nil)],
                                            displayCompletion: nil)
        showErrorAlert(with: viewModel)
    }
    
    func displaySendError(viewModel: ForgotPassword.ViewModel) {
        let errorViewModel = ErrorAlertViewModel(from: viewModel) {
            self.sendButton.handleResponse(with: .failure)
        }
        showErrorAlert(with: errorViewModel)
    }
    
    func displayValidationError(viewModel: ForgotPassword.Validate.ViewModel) {
        emailTextField.failure(error: viewModel.message)
    }
    
    func displayValidationSuccess(viewModel: ForgotPassword.Validate.ViewModel) {
        emailTextField.success()
    }
    
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        if let floatTextField = textField as? CMFloatLabelTextField {
            let request = ForgotPassword.Validate.Request(text: floatTextField.text, textFieldType: .email)
            interactor?.validateTextField(request: request)
        }
    }
    
}
