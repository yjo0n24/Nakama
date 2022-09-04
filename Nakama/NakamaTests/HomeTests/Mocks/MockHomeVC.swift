//
//  MockHomeVC.swift
//  NakamaTests
//
//  Created by Yew Joon Wong on 04/09/2022.
//

import Foundation
@testable import Nakama

class MockHomeVC: HomePresenterProtocol {
    
    private var presenter: HomePresenter!
    
    var didReceivePostsCalled = false
    var rowCount = 0
    var refreshTableView = false
    
    var didReachEndOfPostsCalled = false
    var onErrorCalled = false
    
    init(presenter: HomePresenter) {
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
    
    func onError(errorMessage: String) {
        onErrorCalled = true
    }
}
