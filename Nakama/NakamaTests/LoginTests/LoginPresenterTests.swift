//
//  LoginPresenterTests.swift
//  NakamaTests
//
//  Created by Yew Joon Wong on 29/08/2022.
//

import XCTest
@testable import Nakama

class LoginPresenterTests: XCTestCase {
    
    var subject: LoginPresenter!
    var mockService: MockLoginService!
    var mockVC: MockLoginVC!

    override func setUpWithError() throws {
        super.setUp()
        mockService = MockLoginService()
        subject = LoginPresenter(service: mockService)
        mockVC = MockLoginVC(presenter: subject)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Form validation
    func testvalidateInput_success() throws {
        subject.validateInput("a@gmail.com", "Abcd1234!")
        XCTAssertTrue(mockVC.onFormValidateCalled)
        XCTAssertTrue(mockVC.onFormValidateCallbackValue)
    }
    
    func testvalidateInput_fail() throws {
        subject.validateInput("", "")
        XCTAssertTrue(mockVC.onFormValidateCalled)
        XCTAssertFalse(mockVC.onFormValidateCallbackValue)
    }
    
    func testvalidateInput_emailFail() throws {
        subject.validateInput("some invalid email", "Abcd1234!")
        XCTAssertTrue(mockVC.onFormValidateCalled)
        XCTAssertFalse(mockVC.onFormValidateCallbackValue)
    }
    
    func testvalidateInput_passwordFail() throws {
        subject.validateInput("a@gmail.com", "")
        XCTAssertTrue(mockVC.onFormValidateCalled)
        XCTAssertFalse(mockVC.onFormValidateCallbackValue)
    }
    
    // MARK: - Sign-in service
    func testPerformSignIn_success() throws {
        mockService.shouldFailRequest = false
        subject.performSignIn(email: "a@gmail.com", password: "Abcd1234!")
        XCTAssertTrue(mockVC.onSignInSuccessCalled)
        XCTAssertFalse(mockVC.onErrorCalled)
    }
    
    func testPerformSignIn_fail() throws {
        mockService.shouldFailRequest = true
        subject.performSignIn(email: "a@gmail.com", password: "Abcd1234!")
        XCTAssertTrue(mockVC.onErrorCalled)
        XCTAssertFalse(mockVC.onSignInSuccessCalled)
    }
}
