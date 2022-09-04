//
//  PostEditorModel.swift
//  Nakama
//
//  Created by Yew Joon Wong on 31/08/2022.
//

import Foundation

struct PostModel: Codable {
    let postId: String?
    let userInfo: PostUserInfo
    let textContent: String
    let imageUrl: String?
    let createdDate: Date
    
    init(postId: String?, userInfo: PostUserInfo, textContent: String, imageUrl: String?, createdDate: Date) {
        self.postId = postId
        self.userInfo = userInfo
        self.textContent = textContent
        self.imageUrl = imageUrl
        self.createdDate = createdDate
    }
}

struct PostUserInfo: Codable {
    let userId: String
    let username: String
    let profileImage: String?
}
