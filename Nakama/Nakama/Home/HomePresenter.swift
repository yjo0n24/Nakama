//
//  HomePresenter.swift
//  Nakama
//
//  Created by Yew Joon Wong on 31/08/2022.
//

import Foundation

// MARK: - Protocol
protocol HomePresenterProtocol: AnyObject {
    func didReceivePosts(numOfRows: Int, refreshTableView: Bool)
    func didReachEndOfPosts()
    func onError(errorMessage: String)
}

class HomePresenter {
    
    // MARK: - Variables
    private let homeService: HomeService = HomeService()
    weak var delegate: HomePresenterProtocol?
    private var isGettingPosts = false
    private var postList = [PostModel]()
    
    // MARK: - Methods
    func getPostDisplayData(with index: Int) -> (username: String, userImage: String?, textContent: String, imageUrl: String?) {
        guard index < postList.count else { return ("", nil, "", nil) }
        let post = postList[index]
        return (post.userInfo.username, post.userInfo.profileImage, post.textContent, post.imageUrl)
    }
    
    func performGetPublicPosts(refreshPosts: Bool, numOfPosts: Int = 10) {
        guard !isGettingPosts else { return }
        isGettingPosts = true
        
        homeService.performGetPublicPosts(refreshPosts: refreshPosts, numOfPosts: numOfPosts, completion: { [weak self] (posts, error) in
            guard let self = self else { return }
            self.isGettingPosts = false
            
            DispatchQueue.main.async {
                if let error = error {
                    self.delegate?.onError(errorMessage: error.localizedDescription)
                } else {
                    guard posts.count > 0 else {
                        self.delegate?.didReachEndOfPosts()
                        return
                    }
                    
                    refreshPosts ? self.postList = posts : self.postList.append(contentsOf: posts)
                    self.delegate?.didReceivePosts(numOfRows: self.postList.count, refreshTableView: refreshPosts)
                }
            }
        })
    }
    
    func performGetPostImage(for postAtIndex: Int) {
        guard postAtIndex < postList.count, let imagePath = postList[postAtIndex].imageUrl else { return }
        
        FirebaseStorageHelper.shared.performGetImage(from: imagePath, completion: { (imageData, error) in
            
        })
    }
}
