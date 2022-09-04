//
//  ProfilePresenterTests.swift
//  NakamaTests
//
//  Created by Yew Joon Wong on 04/09/2022.
//

import XCTest
@testable import Nakama

class ProfilePresenterTests: XCTestCase {
    
    var subject: ProfilePresenter!
    var mockService: MockProfileService!
    var mockVC: MockProfileVC!

    override func setUpWithError() throws {
        super.setUp()
        mockService = MockProfileService()
        subject = ProfilePresenter(service: mockService)
        mockVC = MockProfileVC(presenter: subject)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Post fetching related methods
    // Refresh posts
    func testperformGetPublicPostsRefresh_success() {
        mockService.shouldFailRequest = false
        mockService.shouldReturnEmptyPostList = false
        
        subject.performGetPersonalPosts(refreshPosts: true)
        
        XCTAssertTrue(mockVC.didReceivePostsCalled)
        
        // Default number of posts is 10
        XCTAssertEqual(mockVC.rowCount, 10)
        XCTAssertTrue(mockVC.refreshTableView)
    }
    
    // Empty post list
    func testperformGetPublicPostsEmpty() {
        mockService.shouldFailRequest = false
        mockService.shouldReturnEmptyPostList = true
        
        subject.performGetPersonalPosts(refreshPosts: true)
        
        XCTAssertTrue(mockVC.didReachEndOfPostsCalled)
        XCTAssertFalse(mockVC.didReceivePostsCalled)
    }
    
    // Get posts with specified number per page
    func testPerformGetPublicPostsWithCount() {
        mockService.shouldFailRequest = false
        mockService.shouldReturnEmptyPostList = false
        
        subject.performGetPersonalPosts(refreshPosts: false, numOfPosts: 5)
        
        XCTAssertTrue(mockVC.didReceivePostsCalled)
        XCTAssertEqual(mockVC.rowCount, 5)
        XCTAssertFalse(mockVC.refreshTableView)
    }
    
    // Get posts with pagination (check if presenter returns the correct number of posts)
    func testPerformGetPublicPostsPaginate() {
        mockService.shouldFailRequest = false
        mockService.shouldReturnEmptyPostList = false
        
        // Get first 5 posts
        subject.performGetPersonalPosts(refreshPosts: false, numOfPosts: 5)
        
        XCTAssertEqual(mockVC.rowCount, 5)
        
        // Get next 5 posts
        subject.performGetPersonalPosts(refreshPosts: false, numOfPosts: 5)
        
        XCTAssertEqual(mockVC.rowCount, 10)
    }
    
    // Get post data at index
    func testGetPostDisplayData() {
        mockService.shouldFailRequest = false
        mockService.shouldReturnEmptyPostList = false
        
        subject.performGetPersonalPosts(refreshPosts: true)
        
        // Get post data at index 2
        let displayData = subject.getPostDisplayData(with: 2)
        XCTAssert(displayData.textContent == "some content at index: \(3)")
    }
    
    // Get posts failure
    func testperformGetPublicPosts_fail() {
        mockService.shouldFailRequest = true
        
        subject.performGetPersonalPosts(refreshPosts: true)
        
        XCTAssertTrue(mockVC.onErrorCalled)
        XCTAssertFalse(mockVC.didReceivePostsCalled)
        XCTAssertFalse(mockVC.didReachEndOfPostsCalled)
    }
    
    // MARK: - Delete post
    func testPerformDeletePost_success() {
        subject.performGetPersonalPosts(refreshPosts: true)
        
        mockService.shouldFailRequest = false
        subject.performDeletePost(postAt: 5)
        
        XCTAssertTrue(mockVC.onPostDeleteSuccessCalled)
        XCTAssertFalse(mockVC.onErrorCalled)
    }
    
    func testPerformDeletePost_fail() {
        subject.performGetPersonalPosts(refreshPosts: true)
        
        mockService.shouldFailRequest = true
        subject.performDeletePost(postAt: 5)
        
        XCTAssertFalse(mockVC.onPostDeleteSuccessCalled)
        XCTAssertTrue(mockVC.onErrorCalled)
    }
    
    // MARK: - Logout
    func testPerformLogout_success() {
        mockService.shouldFailRequest = false
        subject.performLogout()
        
        XCTAssertTrue(mockVC.onLogoutSuccessCalled)
        XCTAssertFalse(mockVC.onErrorCalled)
    }
    
    func testPerformLogout_fail() {
        mockService.shouldFailRequest = true
        subject.performLogout()
        
        XCTAssertFalse(mockVC.onLogoutSuccessCalled)
        XCTAssertTrue(mockVC.onErrorCalled)
    }
}
