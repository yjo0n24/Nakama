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

// MARK: - NSMutableAttributedString
extension NSMutableAttributedString {
    func colour(text: String, _ colour: UIColor) -> NSMutableAttributedString {
        let range = (self.string as NSString).range(of: text)
        self.addAttributes([NSAttributedString.Key.foregroundColor: colour], range: range)
        return self
    }
    
    func font(text: String, _ font: UIFont) -> NSMutableAttributedString {
        let range = (self.string as NSString).range(of: text)
        self.addAttributes([NSAttributedString.Key.font: font], range: range)
        return self
    }
}

// MARK: - Date
extension Date {
    func displayFormat() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute {
            if secondsAgo > 1 {
                return String(format: StringConstants.PostTime.secondsAgo.localized, secondsAgo)
            } else {
                return String(format: StringConstants.PostTime.secondAgo.localized, secondsAgo)
            }
        } else if secondsAgo < hour {
            if secondsAgo >= 120 {
                return String(format: StringConstants.PostTime.minutesAgo.localized, (secondsAgo / minute))
            } else {
                return String(format: StringConstants.PostTime.minuteAgo.localized, (secondsAgo / minute))
            }
        } else if secondsAgo < day {
            if secondsAgo >= 7200 {
                return String(format: StringConstants.PostTime.hoursAgo.localized, (secondsAgo / hour))
            } else {
                return String(format: StringConstants.PostTime.hourAgo.localized, (secondsAgo / hour))
            }
        } else if secondsAgo < week {
            if secondsAgo >= 172800 {
                return String(format: StringConstants.PostTime.daysAgo.localized, (secondsAgo / day))
            } else {
                return String(format: StringConstants.PostTime.dayAgo.localized, (secondsAgo / day))
            }
        } else {
            if secondsAgo >= 1209600 {
                return String(format: StringConstants.PostTime.weeksAgo.localized, (secondsAgo / week))
            } else {
                return String(format: StringConstants.PostTime.weekAgo.localized, (secondsAgo / week))
            }
        }
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
