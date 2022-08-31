//
//  PostEditorService.swift
//  Nakama
//
//  Created by Yew Joon Wong on 31/08/2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class PostEditorService {
    
    private let db = Firestore.firestore()
    
    func performCreatePost(_ model: PostModel, completion: @escaping (Error?) -> Void) {
        db.collection(SharedConstants.FirestoreCollection.posts).addDocument(data: model.dictionary) { error in
            completion(error)
        }
    }
}
