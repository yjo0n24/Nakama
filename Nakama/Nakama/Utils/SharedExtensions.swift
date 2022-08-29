//
//  SharedExtensions.swift
//  Nakama
//
//  Created by Yew Joon Wong on 26/08/2022.
//

import Foundation

// MARK: - String extension
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
