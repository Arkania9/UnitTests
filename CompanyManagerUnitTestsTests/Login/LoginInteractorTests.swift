//
//    LoginInteractorTests.swift
//    CompanyManagerUnitTests
//
//    Created by Kamil on 01/03/2019.
//    Copyright (c) 2019 Kamil Zając. All rights reserved.
//

@testable import CompanyManagerUnitTests
import XCTest
import Unicorns

class LoginInteractorTests: XCTestCase {

	// MARK: - Subject under test
	
	var interactor: LoginInteractor!
  var presenter: LoginPresentationLogicSpy!
	
	// MARK: - Test lifecycle
	
	override func setUp() {
		super.setUp()
		setupLoginInteractor()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	// MARK: - Test setup
	
	func setupLoginInteractor() {
		interactor = LoginInteractor()
    presenter = LoginPresentationLogicSpy()
    interactor.presenter = presenter
	}
	
	// MARK: - Test spyes
	
  class LoginPresentationLogicSpy: LoginPresentationLogic {
    var isValidationPresented = false
    var isLoginSuccessfulPresented = false
    var isLoginErrorPresented = false
    
    func presentValidation(response: Login.Validate.Response) {
      isValidationPresented = true
    }
    
    func presentLoginSuccess() {
      isLoginSuccessfulPresented = true
    }
    
    func presentLoginError(response: Login.LoginUser.Response) {
      isLoginErrorPresented = true
    }
  }
	
	// MARK: - Tests
  
  func testValidation() {
    let request = Login.Validate.Request(text: "test", textFieldType: .email)
    interactor.validateTextField(request: request)
    XCTAssert(presenter.isValidationPresented, "validateTextField(_) should invoke presentValidation")
  }
  
  func testLoginSuccess() {
    let mockSession = MockURLSession(expectedJSON: JSONMocksManager.json(for: .token), expectedStatusCode: 200)
    Networking.session = mockSession
    let request = Login.LoginUser.Request(email: "test@email.com", password: "testtest")
    interactor.loginUser(request: request)
    XCTAssert(presenter.isLoginSuccessfulPresented, "User should be logged in successfuly")
  }
  
  func testLoginFailure() {
    let mockSession = MockURLSession(expectedJSON: JSONMocksManager.json(for: .error), expectedStatusCode: 401)
    Networking.session = mockSession
    let request = Login.LoginUser.Request(email: "test@email.com", password: "testtest")
    interactor.loginUser(request: request)
    XCTAssert(presenter.isLoginErrorPresented, "User should not be logged")
  }
  
}
