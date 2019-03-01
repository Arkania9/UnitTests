//
//    RegisterPresenterTests.swift
//    CompanyManagerUnitTests
//
//    Created by Kamil on 01/03/2019.
//    Copyright (c) 2019 Kamil Zając. All rights reserved.
//

@testable import CompanyManagerUnitTests
import XCTest

class RegisterPresenterTests: XCTestCase {

	// MARK: - Subject under test
	
	var presenter: RegisterPresenter!
  var viewController: RegisterDisplayLogicSpy!
	
	// MARK: - Test lifecycle
	
	override func setUp() {
		super.setUp()
		setupRegisterPresenter()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	// MARK: - Test setup
	
	func setupRegisterPresenter() {
		presenter = RegisterPresenter()
    viewController = RegisterDisplayLogicSpy()
    presenter.viewController = viewController
	}
	
	// MARK: - Test spyes
	
  class RegisterDisplayLogicSpy: RegisterDisplayLogic {
    var isImagePickerCloseDisplayed = false
    var isUserAvatarDisplayed = false
    var isImagePickerDisplayed = false
    var isValidationErrorDisplayed = false
    var isValidationSuccessDisplayed = false
    var isRegisterSuccessDisplayed = false
    var isRegisterErrorDisplayed = false
    
    func displayImagePickerClosed() {
      isImagePickerCloseDisplayed = true
    }
    
    func displayUserAvatar(viewModel: Register.UserAvatar.ViewModel) {
      isUserAvatarDisplayed = true
    }
    
    func displayImagePicker(viewModel: Register.ImagePicker.ViewModel) {
      isImagePickerDisplayed = true
    }
    
    func displayValidationError(viewModel: Register.Validate.ViewModel) {
      isValidationErrorDisplayed = true
    }
    
    func displayValidationSuccess(viewModel: Register.Validate.ViewModel) {
      isValidationSuccessDisplayed = true
    }
    
    func displayRegisterSuccess() {
      isRegisterSuccessDisplayed = true
    }
    
    func displayRegisterError(viewModel: Register.RegisterUser.ViewModel) {
      isRegisterErrorDisplayed = true
    }
  }
	
	// MARK: - Tests
	
  func testImagePickerClosed() {
    presenter.presentImagePickerClosed()
    XCTAssert(viewController.isImagePickerCloseDisplayed, "Image picker should be closed")
  }
  
  func testUserAvatar() {
    let response = Register.UserAvatar.Response(image: UIImage())
    presenter.presentUserAvatar(response: response)
    XCTAssert(viewController.isUserAvatarDisplayed, "User avatar should be displayed")
  }
  
  func testImagePickerDisplay() {
    let response = Register.ImagePicker.Response(picker: UIImagePickerController())
    presenter.presentImagePicker(response: response)
    XCTAssert(viewController.isImagePickerDisplayed, "Image picker should be displayed")
  }
  
  func testValidationError() {
    let response = Register.Validate.Response(validationResponse: ValidationResponse(validated: false,
                                                                                     message: "Error"),
                                              textFieldType: .email)
    presenter.presentValidation(response: response)
    XCTAssert(viewController.isValidationErrorDisplayed, "Validation error should be displayed")
  }
  
  func testValidationSuccess() {
    let response = Register.Validate.Response(validationResponse: ValidationResponse(validated: true, message: nil),
                                              textFieldType: .email)
    presenter.presentValidation(response: response)
    XCTAssert(viewController.isValidationSuccessDisplayed, "Validation success should be displayed")
  }
  
  func testRegisterSuccess() {
    presenter.presentRegisterSuccess()
    XCTAssert(viewController.isRegisterSuccessDisplayed, "Register success should be displayed")
  }
  
  func testRegisterError() {
    let response = Register.RegisterUser.Response(error: AppError(description: "Something went wrong"))
    presenter.presentRegisterError(response: response)
    XCTAssert(viewController.isRegisterErrorDisplayed, "Register error should be displayed")
  }
  
}
