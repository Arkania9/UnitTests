//
//    RegisterInteractorTests.swift
//    CompanyManagerUnitTests
//
//    Created by Kamil on 01/03/2019.
//    Copyright (c) 2019 Kamil Zając. All rights reserved.
//

@testable import CompanyManagerUnitTests
import XCTest
import Unicorns

class RegisterInteractorTests: XCTestCase {
  
  // MARK: - Subject under test
  
  var interactor: RegisterInteractor!
  var presenter: RegisterPresentationLogicSpy!
  
  // MARK: - Test lifecycle
  
  override func setUp() {
    super.setUp()
    setupRegisterInteractor()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: - Test setup
  
  func setupRegisterInteractor() {
    interactor = RegisterInteractor()
    presenter = RegisterPresentationLogicSpy()
    interactor.presenter = presenter
  }
  
  // MARK: - Test spyes
  
  class RegisterPresentationLogicSpy: RegisterPresentationLogic {
    var isValidationPresented = false
    var isRegisterSuccessPresented = false
    var isRegisterErrorPresented = false
    var isImagePickerClosed = false
    var isUserAvatarPresented = false
    var isImagePickerPresented = false
    
    func presentValidation(response: Register.Validate.Response) {
      isValidationPresented = true
    }
    
    func presentRegisterSuccess() {
      isRegisterSuccessPresented = true
    }
    
    func presentRegisterError(response: Register.RegisterUser.Response) {
      isRegisterErrorPresented = true
    }
    
    func presentImagePickerClosed() {
      isImagePickerClosed = true
    }
    
    func presentUserAvatar(response: Register.UserAvatar.Response) {
      isUserAvatarPresented = true
    }
    
    func presentImagePicker(response: Register.ImagePicker.Response) {
      isImagePickerPresented = true
    }
  }
  
  // MARK: - Tests
  
  func testValidation() {
    let request = Register.Validate.Request(text: "test", textFieldType: .email)
    interactor.validateTextField(request: request)
    XCTAssert(presenter.isValidationPresented, "validateTextField(_) should invoke presentValidation")
  }
  
  func testRegisterSuccess() {
    let mockSession = MockURLSession(expectedJSON: JSONMocksManager.json(for: .token), expectedStatusCode: 200)
    Networking.session = mockSession
    let request = Register.RegisterUser.Request(firstName: "testUser",
                                                lastName: "testName",
                                                email: "test@email.test",
                                                password: "testPassword1",
                                                confirmPassword: "testPassword1",
                                                referalCode: nil)
    interactor.registerUser(request: request)
    XCTAssert(presenter.isRegisterSuccessPresented, "User should be registered successfuly")
  }
  
  func testRegisterFailure() {
    let mockSession = MockURLSession(expectedJSON: JSONMocksManager.json(for: .error), expectedStatusCode: 401)
    Networking.session = mockSession
    let request = Register.RegisterUser.Request(firstName: "testUser",
                                                lastName: "testName",
                                                email: "test",
                                                password: "testPassword",
                                                confirmPassword: "testPassword",
                                                referalCode: nil)
    interactor.registerUser(request: request)
    XCTAssert(presenter.isRegisterErrorPresented, "User should not be be registered successfuly")
  }
  
  func testImagePickerClosedByCancel() {
    let picker = UIImagePickerController()
    interactor?.imagePickerControllerDidCancel(picker)
    XCTAssert(presenter.isImagePickerClosed, "ImagePicker should be dismissed when cancel")
  }
  
  func testImagePickerClosedBySuccess() {
    let picker = UIImagePickerController()
    interactor?.imagePickerController(picker, didFinishPickingMediaWithInfo: [.originalImage: UIImage()])
    XCTAssert(presenter.isImagePickerClosed, "ImagePicker should be dismissed when picked image")
  }
  
  func testUserAvatarPresentation() {
    let picker = UIImagePickerController()
    interactor?.imagePickerController(picker, didFinishPickingMediaWithInfo: [.originalImage: UIImage()])
    XCTAssert(presenter.isUserAvatarPresented, "User's avatar should be presented")
  }
  
  func testImagePickerPresented() {
    interactor?.selectUserAvatar()
    XCTAssert(presenter.isImagePickerPresented, "Image picker should be presented")
  }
  
}
