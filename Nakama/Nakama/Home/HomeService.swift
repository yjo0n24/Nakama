//
//  HomeService.swift
//  Nakama
//
//  Created by Yew Joon Wong on 31/08/2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class HomeService {
    
    private let db = Firestore.firestore()
    private var postsLastSnapshot: QueryDocumentSnapshot?
    
    func performGetPublicPosts(refreshPosts: Bool, numOfPosts: Int, completion: @escaping ([PostModel], Error?) -> Void) {
        var postsRef = db.collection(SharedConstants.Firestore.Collection.posts)
            .limit(to: numOfPosts)
            .order(by: "createdDate", descending: true)
        
        if refreshPosts {
            postsLastSnapshot = nil
        } else {
            if let postsLastSnapshot = postsLastSnapshot {
                postsRef = postsRef.start(afterDocument: postsLastSnapshot)
            }
        }
        
        postsRef.addSnapshotListener({ [weak self] (snapshot, error) in
            guard let snapshot = snapshot else {
                completion([], error)
                return
            }
            if let lastSnapshot = snapshot.documents.last {
                self?.postsLastSnapshot = lastSnapshot
            }
            
            let documentsDict = snapshot.documents.map({ $0.data() })
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: documentsDict, options: .prettyPrinted)
                let posts = try JSONDecoder().decode([PostModel].self, from: jsonData)
                completion(posts, error)
                
            } catch {
                completion([], error)
            }
        })
    }
}
