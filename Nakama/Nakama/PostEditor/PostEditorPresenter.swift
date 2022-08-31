//
//  PostEditorPresenter.swift
//  Nakama
//
//  Created by Yew Joon Wong on 31/08/2022.
//

import Foundation

// MARK: - Protocol
protocol PostEditorPresenterProtocol: AnyObject {
    func didValidateInput(isValid: Bool)
    func onCreatePostSuccess()
    func onError(errorMessage: String)
}

class PostEditorPresenter {
    
    // MARK: - Variables
    private let postEditorService: PostEditorService = PostEditorService()
    weak var delegate: PostEditorPresenterProtocol?
    
    // MARK: - Methods
    func validateInput(_ input: String) {
        delegate?.didValidateInput(isValid: !input.isEmpty)
    }
    
    func performCreatePost(textContent: String, imageData: Data?) {
        if let imageData = imageData {
            FirebaseStorageHelper.shared.performSaveImage(
                imageData,
                refPath: SharedConstants.FirebaseStorageRef.posts,
                completion: { [weak self] (imageUrl, error) in
                
                guard let self = self else { return }
                
                if let error = error {
                    self.delegate?.onError(errorMessage: error.localizedDescription)
                } else {
                    self.performCreatePostService(textContent: textContent, imageUrl: imageUrl)
                }
            })
        } else {
            performCreatePostService(textContent: textContent, imageUrl: nil)
        }
    }
    
    private func performCreatePostService(textContent: String, imageUrl: String?) {
        let currentUser = UserDataHelper().getLoginInfo()
        guard !currentUser.userId.isEmpty else { return }
        
        let userInfo = PostUserInfo(
            userId: currentUser.userId,
            username: currentUser.username,
            profileImage: currentUser.profileImage
        )
        
        let df = DateFormatter()
        df.dateFormat = SharedConstants.DateFormat.postCreatedDate
        let createdDate = df.string(from: Date())
        
        let model = PostModel(
            userInfo: userInfo,
            textContent: textContent,
            imageUrl: imageUrl,
            createdDate: createdDate
        )
        
        postEditorService.performCreatePost(model, completion: { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.onError(errorMessage: error.localizedDescription)
            } else {
                self.delegate?.onCreatePostSuccess()
            }
        })
    }
}
