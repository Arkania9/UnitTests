//
//    ForgotPasswordInteractorTests.swift
//    CompanyManagerUnitTests
//
//    Created by Kamil on 01/03/2019.
//    Copyright (c) 2019 Kamil Zając. All rights reserved.
//

@testable import CompanyManagerUnitTests
import XCTest
import Unicorns

class ForgotPasswordInteractorTests: XCTestCase {

	// MARK: - Subject under test
	
	private var interactor: ForgotPasswordInteractor!
  private var presenter: ForgotPasswordPresentationLogicSpy!
	
	// MARK: - Test lifecycle
	
	override func setUp() {
		super.setUp()
		setupForgotPasswordInteractor()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	// MARK: - Test setup
	
	func setupForgotPasswordInteractor() {
		interactor = ForgotPasswordInteractor()
    presenter = ForgotPasswordPresentationLogicSpy()
    interactor.presenter = presenter
	}
	
	// MARK: - Test spyes
	
	class ForgotPasswordPresentationLogicSpy: ForgotPasswordPresentationLogic {
    var isValidationPresented = false
    var isForgotPasswordSuccessPresented = false
    var isForgotPasswordErrorPresented = false
    
    func presentValidation(response: ForgotPassword.Validate.Response) {
      isValidationPresented = true
    }
    
    func presentForgotPasswordSuccess() {
      isForgotPasswordSuccessPresented = true
    }
    
    func presentForgotPasswordError(response: ForgotPassword.Response) {
      isForgotPasswordErrorPresented = true
    }
  }
	
	// MARK: - Tests
	
  func testValidation() {
    let request = ForgotPassword.Validate.Request(text: "test", textFieldType: .email)
    interactor.validateTextField(request: request)
    XCTAssert(presenter.isValidationPresented, "validateTextField(_) should invoke presentValidation")
  }
  
  func testForgotPasswordSuccess() {
    let mockSession = MockURLSession(expectedJSON: JSONMocksManager.json(for: .success), expectedStatusCode: 200)
    Networking.session = mockSession
    let request = ForgotPassword.Request(email: "test@email.test")
    interactor.sendPassword(request: request)
    XCTAssert(presenter.isForgotPasswordSuccessPresented, "User should be registered successfuly")
  }
  
  func testForgotPasswordFailure() {
    let mockSession = MockURLSession(expectedJSON: JSONMocksManager.json(for: .error), expectedStatusCode: 401)
    Networking.session = mockSession
    let request = ForgotPassword.Request(email: "test")
    interactor.sendPassword(request: request)
    XCTAssert(presenter.isForgotPasswordErrorPresented, "User should be registered successfuly")
  }
  
}
