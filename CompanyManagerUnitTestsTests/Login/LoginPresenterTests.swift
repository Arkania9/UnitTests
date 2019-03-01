//
//    LoginPresenterTests.swift
//    CompanyManagerUnitTests
//
//    Created by Kamil on 01/03/2019.
//    Copyright (c) 2019 Kamil Zając. All rights reserved.
//

@testable import CompanyManagerUnitTests
import XCTest

class LoginPresenterTests: XCTestCase {
  
  // MARK: - Subject under test
  
  var presenter: LoginPresenter!
  var viewController: LoginDisplayLogicSpy!
  
  // MARK: - Test lifecycle
  
  override func setUp() {
    super.setUp()
    setupLoginPresenter()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: - Test setup
  
  func setupLoginPresenter() {
    presenter = LoginPresenter()
    viewController = LoginDisplayLogicSpy()
    presenter.viewController = viewController
  }
  
  // MARK: - Test spyes
  
  class LoginDisplayLogicSpy: LoginDisplayLogic {
    var validationErrorDisplayed = false
    var validationSuccessDisplayed = false
    var loginSuccessDisplayed = false
    var loginErrorDisplayed = false
    
    func displayValidationError(viewModel: Login.Validate.ViewModel) {
      validationErrorDisplayed = true
    }
    
    func displayValidationSuccess(viewModel: Login.Validate.ViewModel) {
      validationSuccessDisplayed = true
    }
    
    func displayLoginSuccess() {
      loginSuccessDisplayed = true
    }
    
    func displayLoginError(viewModel: Login.LoginUser.ViewModel) {
      loginErrorDisplayed = true
    }
  }
  
  // MARK: - Tests
  
  func testValidationSuccess() {
    let response = Login.Validate.Response(validationResponse: ValidationResponse(validated: true, message: nil),
                                           textFieldType: .firstName)
    
    presenter.presentValidation(response: response)
    XCTAssert(viewController.validationSuccessDisplayed, "Validation success should be displayed")
  }
  
  func testValidationFailure() {
    let response = Login.Validate.Response(validationResponse: ValidationResponse(validated: false, message: "Failure"),
                                           textFieldType: .firstName)
    
    presenter.presentValidation(response: response)
    XCTAssert(viewController.validationErrorDisplayed, "Validation error should be displayed")
  }
  
  func testLoginSuccess() {
    presenter.presentLoginSuccess()
    XCTAssert(viewController.loginSuccessDisplayed, "Login success should be displayed")
  }
  
  func testLoginError() {
    let response = Login.LoginUser.Response(error: AppError(description: "Something went wrong"))
    presenter.presentLoginError(response: response)
    XCTAssert(viewController.loginErrorDisplayed, "Login error should be displayed")
  }
  
}
