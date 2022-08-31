//
//  HomePresenter.swift
//  Nakama
//
//  Created by Yew Joon Wong on 31/08/2022.
//

import Foundation

// MARK: - Protocol
protocol HomePresenterProtocol: AnyObject {
    func reloadData(numOfRows: Int)
    func onError(errorMessage: String)
}

class HomePresenter {
    
    // MARK: - Variables
    private let homeService: HomeService = HomeService()
    weak var delegate: HomePresenterProtocol?
    private var postList = [PostModel]()
    
    // MARK: - Methods
    func getPostDisplayData(with index: Int) -> (username: String, textContent: String) {
        guard index < postList.count else { return ("", "") }
        let post = postList[index]
        return (post.userInfo.username, post.textContent)
    }
    
    func performGetPublicPosts() {
        homeService.performGetPublicPosts(refreshPosts: false, completion: { [weak self] (posts, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.onError(errorMessage: error.localizedDescription)
            } else {
                self.postList = posts
                self.delegate?.reloadData(numOfRows: posts.count)
            }
        })
    }
}
