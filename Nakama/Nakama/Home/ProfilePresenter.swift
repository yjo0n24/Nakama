//
//  ProfilePresenter.swift
//  Nakama
//
//  Created by Yew Joon Wong on 01/09/2022.
//

import Foundation

// MARK: - Protocol
protocol ProfilePresenterProtocol: AnyObject {
    func didReceivePosts(numOfRows: Int, refreshTableView: Bool)
    func didReachEndOfPosts()
    func onPostDeleteSuccess(message: String)
    func onLogoutSuccess()
    func onError(errorMessage: String)
}

class ProfilePresenter {
    
    // MARK: - Variables
    private let profileService: ProfileService!
    weak var delegate: ProfilePresenterProtocol?
    private var isGettingPosts = false
    private var postList = [PostModel]()
    
    // MARK: - Methods
    init(service: ProfileService) {
        profileService = service
    }
    
    func getUsername() -> String {
        return UserDataHelper().getLoginInfo().username
    }
    
    func getUserProfileImageUrl() -> URL? {
        return URL(string: UserDataHelper().getLoginInfo().profileImage ?? "")
    }
    
    func getPostDisplayData(with index: Int) ->
    (username: String, userImage: String?, textContent: String, imageUrl: String?, createdDate: String) {
        
        guard index < postList.count else { return ("", nil, "", nil, "") }
        let post = postList[index]
        return (post.userInfo.username, post.userInfo.profileImage, post.textContent, post.imageUrl, post.createdDate.displayFormat())
    }
    
    // MARK: - Service methods
    func performGetPersonalPosts(refreshPosts: Bool, numOfPosts: Int = 10) {
        guard !isGettingPosts else { return }
        isGettingPosts = true
        
        profileService.performGetPersonalPosts(refreshPosts: refreshPosts, numOfPosts: numOfPosts,
                                            completion: { [weak self] (posts, error) in
            
            guard let self = self else { return }
            self.isGettingPosts = false
            
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
        })
    }
    
    func performDeletePost(postAt index: Int) {
        guard index < postList.count, let postId = postList[index].postId else { return }
        
        profileService.performDeletePost(for: postId, completion: { [weak self] (error) in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.onError(errorMessage: error.localizedDescription)
            } else {
                self.delegate?.onPostDeleteSuccess(message: StringConstants.Profile.alertDeletePostSuccessMsg.localized)
            }
        })
    }
    
    func performLogout() {
        profileService.performLogout(completion: { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.onError(errorMessage: error.localizedDescription)
            } else {
                self.delegate?.onLogoutSuccess()
            }
        })
    }
}
