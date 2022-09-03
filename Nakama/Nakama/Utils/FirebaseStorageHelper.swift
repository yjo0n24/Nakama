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
            postImageRef.downloadURL(completion: { (downloadUrl, error) in
                completion(downloadUrl?.absoluteString ?? "", error)
            })
        })
    }
    
    func performGetImage(from path: String, completion: @escaping (Data?, Error?) -> Void) {
        let storageRef = storage.reference(withPath: path)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (imageData, error) in
            completion(imageData, error)
        }
    }
}
