//
//  SharedExtensions.swift
//  Nakama
//
//  Created by Yew Joon Wong on 26/08/2022.
//

import Foundation
import UIKit

// MARK: - String
extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func isValidFormat(with regEx: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self)
    }
}

// MARK: - NotificationCenter
extension Notification.Name {
    static let setRootVC = Notification.Name("setRootVC")
}

// MARK: - Encodable
extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}

// MARK: - UIImage
extension UIImage {
    var jpegData: Data? {
        self.jpegData(compressionQuality: 1)
    }
}
