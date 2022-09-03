//
//  RegistrationPresenterTests.swift
//  NakamaTests
//
//  Created by Yew Joon Wong on 04/09/2022.
//

import XCTest
@testable import Nakama

class RegistrationPresenterTests: XCTestCase {
    
    var subject: RegistrationPresenter!
    var mockService: MockRegistrationService!
    var mockVC: MockRegistrationVC!

    override func setUpWithError() throws {
        mockService = MockRegistrationService()
        subject = RegistrationPresenter(service: mockService)
        mockVC = MockRegistrationVC(presenter: subject)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Form validation
    func testValidateUsername_success() {
        subject.validateUsername("TesterName")
        XCTAssertTrue(mockVC.onFormValidateCalled)
        XCTAssertTrue(mockVC.onFormValidateCallbackValue)
    }
    
    func testValidateUsername_fail() {
        subject.validateUsername("")
        XCTAssertTrue(mockVC.onFormValidateCalled)
        XCTAssertFalse(mockVC.onFormValidateCallbackValue)
    }
    
    func testValidateCredentials_success() {
        subject.validateCredentials(email: "a@gmail.com", password: "Abcd1234!", confirmPassword: "Abcd1234!")
        XCTAssertTrue(mockVC.onFormValidateCalled)
        XCTAssertTrue(mockVC.onFormValidateCallbackValue)
        XCTAssertFalse(mockVC.onErrorValidateCredentialsCalled)
    }
    
    func testValidateCredentials_fail() {
        subject.validateCredentials(email: "", password: "", confirmPassword: "")
        XCTAssertFalse(mockVC.onFormValidateCalled)
        XCTAssertFalse(mockVC.onFormValidateCallbackValue)
        XCTAssertTrue(mockVC.onErrorValidateCredentialsCalled)
    }
    
    func testValidateCredentials_emailFail() {
        subject.validateCredentials(email: "invalid", password: "Abcd1234!", confirmPassword: "Abcd1234!")
        XCTAssertFalse(mockVC.onFormValidateCalled)
        XCTAssertFalse(mockVC.onFormValidateCallbackValue)
        XCTAssertTrue(mockVC.onErrorValidateCredentialsCalled)
    }
    
    func testValidateCredentials_passwordFail() {
        subject.validateCredentials(email: "a@gmail.com", password: "abc", confirmPassword: "abc")
        XCTAssertFalse(mockVC.onFormValidateCalled)
        XCTAssertFalse(mockVC.onFormValidateCallbackValue)
        XCTAssertTrue(mockVC.onErrorValidateCredentialsCalled)
    }
    
    func testValidateCredentials_passwordMismatchFail() {
        subject.validateCredentials(email: "a@gmail.com", password: "Abcd1234!", confirmPassword: "Abcd1234@")
        XCTAssertFalse(mockVC.onFormValidateCalled)
        XCTAssertFalse(mockVC.onFormValidateCallbackValue)
        XCTAssertTrue(mockVC.onErrorValidateCredentialsCalled)
    }
    
    // MARK: - Sign-up service
    func testPerformSignUp_success() {
        mockService.shouldFailRequest = false
        subject.performSignUpService(username: "TesterName", email: "a@gmail.com", password: "Abcd1234!", profileImage: nil)
        XCTAssertTrue(mockVC.onSignUpSuccessCalled)
        XCTAssertFalse(mockVC.onErrorCalled)
    }
    
    func testPerformSignUp_fail() {
        mockService.shouldFailRequest = true
        subject.performSignUpService(username: "TesterName", email: "a@gmail.com", password: "Abcd1234!", profileImage: nil)
        XCTAssertFalse(mockVC.onSignUpSuccessCalled)
        XCTAssertTrue(mockVC.onErrorCalled)
    }
}
