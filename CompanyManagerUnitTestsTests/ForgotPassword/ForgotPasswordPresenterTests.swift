//
//    ForgotPasswordPresenterTests.swift
//    CompanyManagerUnitTests
//
//    Created by Kamil on 01/03/2019.
//    Copyright (c) 2019 Kamil Zając. All rights reserved.
//

@testable import CompanyManagerUnitTests
import XCTest

class ForgotPasswordPresenterTests: XCTestCase {

	// MARK: - Subject under test
	
	private var presenter: ForgotPasswordPresenter!
  private var viewController: ForgotPasswordDisplayLogicSpy!
	
	// MARK: - Test lifecycle
	
	override func setUp() {
		super.setUp()
		setupForgotPasswordPresenter()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	// MARK: - Test setup
	
	func setupForgotPasswordPresenter() {
		presenter = ForgotPasswordPresenter()
    viewController = ForgotPasswordDisplayLogicSpy()
    presenter.viewController = viewController
	}
	
	// MARK: - Test spyes
	
	class ForgotPasswordDisplayLogicSpy: ForgotPasswordDisplayLogic {
    var isSendSuccessDisplayed = false
    var isSendErrorDisplayed = false
    var isValidationErrorDisplayed = false
    var isValidationSuccessDisplayed = false
    
    func displaySendSuccess() {
      isSendSuccessDisplayed = true
    }
    
    func displaySendError(viewModel: ForgotPassword.ViewModel) {
      isSendErrorDisplayed = true
    }
    
    func displayValidationError(viewModel: ForgotPassword.Validate.ViewModel) {
      isValidationErrorDisplayed = true
    }
    
    func displayValidationSuccess(viewModel: ForgotPassword.Validate.ViewModel) {
      isValidationSuccessDisplayed = true
    }
  }
	
	// MARK: - Tests
	
  func testSendSuccessDisplay() {
    presenter?.presentForgotPasswordSuccess()
    XCTAssert(viewController.isSendSuccessDisplayed, "Send success should be displayed")
  }
  
  func testSendErrorDisplay() {
    let response = ForgotPassword.Response(error: AppError(description: "Something went wrong"))
    presenter?.presentForgotPasswordError(response: response)
    XCTAssert(viewController.isSendErrorDisplayed, "Send error should be displayed")
  }
  
  func testValidationErrorDisplay() {
    let validationResponse = ValidationResponse(validated: false, message: "error")
    let response = ForgotPassword.Validate.Response(validationResponse: validationResponse, textFieldType: .email)
    presenter?.presentValidation(response: response)
    XCTAssert(viewController.isValidationErrorDisplayed, "Validation success should be displayed")
  }
  
  func testValidationSuccessDisplay() {
    let validationResponse = ValidationResponse(validated: true, message: nil)
    let response = ForgotPassword.Validate.Response(validationResponse: validationResponse, textFieldType: .email)
    presenter?.presentValidation(response: response)
    XCTAssert(viewController.isValidationSuccessDisplayed, "Validation success should be displayed")
  }
  
}
