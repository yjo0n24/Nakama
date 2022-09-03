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
        let timestamp = Timestamp(date: model.createdDate)
        var modelDict = model.dictionary
        modelDict["createdDate"] = timestamp
        
        db.collection(SharedConstants.Firestore.Collection.posts).addDocument(data: model.dictionary) { error in
            completion(error)
        }
    }
}
