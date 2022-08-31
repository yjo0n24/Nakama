//
//  PostEditorModel.swift
//  Nakama
//
//  Created by Yew Joon Wong on 31/08/2022.
//

import Foundation

struct PostModel: Codable {
    let userInfo: PostUserInfo
    let textContent: String
    let imageUrl: String?
    let createdDate: String
}

struct PostUserInfo: Codable {
    let userId: String
    let username: String
    let profileImage: String?
}
