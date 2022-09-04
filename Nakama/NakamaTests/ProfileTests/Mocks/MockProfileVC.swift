//
//  MockProfileVC.swift
//  NakamaTests
//
//  Created by Yew Joon Wong on 04/09/2022.
//

import Foundation
@testable import Nakama

class MockProfileVC: ProfilePresenterProtocol {
    
    private var presenter: ProfilePresenter!
    
    var didReceivePostsCalled = false
    var rowCount = 0
    var refreshTableView = false
    
    var didReachEndOfPostsCalled = false
    var onPostDeleteSuccessCalled = false
    var onLogoutSuccessCalled = false
    var onErrorCalled = false
    
    init(presenter: ProfilePresenter) {
        self.presenter = presenter
        self.presenter.delegate = self
    }
    
    func didReceivePosts(numOfRows: Int, refreshTableView: Bool) {
        didReceivePostsCalled = true
        rowCount = numOfRows
        self.refreshTableView = refreshTableView
    }
    
    func didReachEndOfPosts() {
        didReachEndOfPostsCalled = true
    }
    
    func onPostDeleteSuccess(message: String) {
        onPostDeleteSuccessCalled = true
    }
    
    func onLogoutSuccess() {
        onLogoutSuccessCalled = true
    }
    
    func onError(errorMessage: String) {
        onErrorCalled = true
    }
}
