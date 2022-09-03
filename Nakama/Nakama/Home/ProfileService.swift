//
//  ProfileService.swift
//  Nakama
//
//  Created by Yew Joon Wong on 01/09/2022.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class ProfileService {
    
    private let db = Firestore.firestore()
    private var postsLastSnapshot: QueryDocumentSnapshot?
    
    func performGetPersonalPosts(refreshPosts: Bool, numOfPosts: Int, completion: @escaping ([PostModel], Error?) -> Void) {
        let currentUser = UserDataHelper().getLoginInfo()
        let userInfo = PostUserInfo(
            userId: currentUser.userId,
            username: currentUser.username,
            profileImage: currentUser.profileImage
        ).dictionary
        
        var postsRef = db.collection(SharedConstants.Firestore.Collection.posts)
            .whereField("userInfo", isEqualTo: userInfo)
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
            
            var documentsDict = [[String: Any]]()
            for document in snapshot.documents {
                var documentDict = document.data()
                documentDict["postId"] = document.documentID
                documentsDict.append(documentDict)
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: documentsDict, options: .prettyPrinted)
                let posts = try JSONDecoder().decode([PostModel].self, from: jsonData)
                completion(posts, error)
                
            } catch {
                completion([], error)
            }
        })
    }
    
    func performDeletePost(for postId: String, completion: @escaping (Error?) -> Void) {
        db.collection(SharedConstants.Firestore.Collection.posts).document(postId).delete { error in
            completion(error)
        }
    }
    
    func performLogout(completion: (NSError?) -> Void) {
        let auth = Auth.auth()
        
        do {
            try auth.signOut()
            UserDataHelper().deleteLoginInfo()
            completion(nil)
            
        } catch let logoutError as NSError {
            completion(logoutError)
        }
    }
}
