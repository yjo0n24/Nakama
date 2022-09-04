//
//  HomePresenterTests.swift
//  NakamaTests
//
//  Created by Yew Joon Wong on 04/09/2022.
//

import XCTest
@testable import Nakama

class HomePresenterTests: XCTestCase {
    
    var subject: HomePresenter!
    var mockService: MockHomeService!
    var mockVC: MockHomeVC!

    override func setUpWithError() throws {
        super.setUp()
        mockService = MockHomeService()
        subject = HomePresenter(service: mockService)
        mockVC = MockHomeVC(presenter: subject)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Refresh posts
    func testperformGetPublicPostsRefresh_success() {
        mockService.shouldFailRequest = false
        mockService.shouldReturnEmptyPostList = false
        
        subject.performGetPublicPosts(refreshPosts: true)
        
        XCTAssertTrue(mockVC.didReceivePostsCalled)
        
        // Default number of posts is 10
        XCTAssertEqual(mockVC.rowCount, 10)
        XCTAssertTrue(mockVC.refreshTableView)
    }
    
    // Empty post list
    func testperformGetPublicPostsEmpty() {
        mockService.shouldFailRequest = false
        mockService.shouldReturnEmptyPostList = true
        
        subject.performGetPublicPosts(refreshPosts: true)
        
        XCTAssertTrue(mockVC.didReachEndOfPostsCalled)
        XCTAssertFalse(mockVC.didReceivePostsCalled)
    }
    
    // Get posts with specified number per page
    func testPerformGetPublicPostsWithCount() {
        mockService.shouldFailRequest = false
        mockService.shouldReturnEmptyPostList = false
        
        subject.performGetPublicPosts(refreshPosts: false, numOfPosts: 5)
        
        XCTAssertTrue(mockVC.didReceivePostsCalled)
        XCTAssertEqual(mockVC.rowCount, 5)
        XCTAssertFalse(mockVC.refreshTableView)
    }
    
    // Get posts with pagination (check if presenter returns the correct number of posts)
    func testPerformGetPublicPostsPaginate() {
        mockService.shouldFailRequest = false
        mockService.shouldReturnEmptyPostList = false
        
        // Get first 5 posts
        subject.performGetPublicPosts(refreshPosts: false, numOfPosts: 5)
        
        XCTAssertEqual(mockVC.rowCount, 5)
        
        // Get next 5 posts
        subject.performGetPublicPosts(refreshPosts: false, numOfPosts: 5)
        
        XCTAssertEqual(mockVC.rowCount, 10)
    }
    
    // Get post data at index
    func testGetPostDisplayData() {
        mockService.shouldFailRequest = false
        mockService.shouldReturnEmptyPostList = false
        
        subject.performGetPublicPosts(refreshPosts: true)
        
        // Get post data at index 2
        let displayData = subject.getPostDisplayData(with: 2)
        XCTAssert(displayData.username == "Tester\(3)")
    }
    
    // Get posts failure
    func testperformGetPublicPosts_fail() {
        mockService.shouldFailRequest = true
        
        subject.performGetPublicPosts(refreshPosts: true)
        
        XCTAssertTrue(mockVC.onErrorCalled)
        XCTAssertFalse(mockVC.didReceivePostsCalled)
        XCTAssertFalse(mockVC.didReachEndOfPostsCalled)
    }
}
