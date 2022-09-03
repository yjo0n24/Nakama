//
//  SharedConstants.swift
//  Nakama
//
//  Created by Yew Joon Wong on 26/08/2022.
//

import Foundation

struct SharedConstants {
    
    struct RegEx {
        static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        static let password = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$"
    }
    
    struct StoryboardName {
        static let login = "Login"
        static let home = "Home"
    }
    
    struct StoryboardId {
        static let loginVC = "LoginVC"
        static let registrationVC = "RegistrationVC"
    }
    
    struct Key {
        static let storyboardName = "storyboardName"
        static let contentSize = "contentSize"
    }
    
    struct UserDefaultsKey {
        static let userId = "userId"
        static let email = "userEmail"
        static let username = "username"
        static let profileImage = "profileImage"
    }
    
    struct Firestore {
        struct Collection {
            static let posts = "posts"
        }
        
        struct Storage {
            static let users = "userImages/%@"
            static let posts = "postImages/%@"
        }
    }
    
    struct DateFormat {
        static let postCreatedDate = "dd/MM/yyyy hh:mm:ss"
    }
}
