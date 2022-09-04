//
//  MockHomeService.swift
//  NakamaTests
//
//  Created by Yew Joon Wong on 04/09/2022.
//

import Foundation
@testable import Nakama

class MockHomeService: HomeService {

    var shouldFailRequest = false
    var shouldReturnEmptyPostList = false
    private var lastIndex = 0
    
    override func performGetPublicPosts(refreshPosts: Bool, numOfPosts: Int, completion: @escaping ([PostModel], Error?) -> Void) {
        guard !shouldFailRequest else {
            let error = NSError(domain: "", code: 500)
            completion([], error)
            return
        }
        
        if shouldReturnEmptyPostList {
            completion([], nil)
        } else {
            let mockPosts = getMockPosts(numOfPosts: 20)
            
            let currentIndex = refreshPosts ? 0 : lastIndex
            let nextLastIndex = currentIndex + (numOfPosts - 1)
            
            if currentIndex < mockPosts.count && nextLastIndex < mockPosts.count {
                let postsToReturn = Array(mockPosts[currentIndex...nextLastIndex])
                lastIndex = nextLastIndex
                completion(postsToReturn, nil)
            } else {
                completion([], nil)
            }
        }
    }
    
    private func getMockPosts(numOfPosts: Int = 10) -> [PostModel] {
        var mockPosts = [PostModel]()
        
        for i in 1...numOfPosts {
            let userInfoModel = PostUserInfo(
                userId: String(i),
                username: "Tester\(i)",
                profileImage: nil
            )
            let postModel = PostModel(
                postId: String(i),
                userInfo: userInfoModel,
                textContent: "some content",
                imageUrl: nil,
                createdDate: Date()
            )
            mockPosts.append(postModel)
        }
        
        return mockPosts
    }
}
