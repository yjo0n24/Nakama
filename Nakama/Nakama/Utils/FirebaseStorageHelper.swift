//
//  FirebaseStorageHelper.swift
//  Nakama
//
//  Created by Yew Joon Wong on 31/08/2022.
//

import Foundation
import FirebaseStorage

class FirebaseStorageHelper {
    
    static let shared = FirebaseStorageHelper()
    private let storage = Storage.storage()
    
    func performSaveImage(_ imageData: Data, refPath: String, completion: @escaping (String, Error?) -> Void) {
        let storageRef = storage.reference()
        let postImageRefPath = String(format: refPath, UUID().uuidString)
        let postImageRef = storageRef.child(postImageRefPath)
        
        postImageRef.putData(imageData, completion: { (metadata, error) in
            completion(postImageRefPath, error)
        })
    }
}
