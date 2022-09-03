//
//  BaseUIViewController.swift
//  Nakama
//
//  Created by Yew Joon Wong on 29/08/2022.
//

import UIKit

class BaseUIViewController: UIViewController {
    
    func showAlert(message: String) {
        showAlert(title: StringConstants.Error.titleGeneral.localized, message: message)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.General.btnOk.localized, style: .default))
        self.present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String, actionTitle: String, completion: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { action in
            completion(action)
        }))
        alert.addAction(UIAlertAction(title: StringConstants.General.btnCancel.localized, style: .cancel, handler: { action in
            completion(action)
        }))
        self.present(alert, animated: true)
    }
    
    func routeToHome() {
        let userInfo = [SharedConstants.Key.storyboardName: SharedConstants.StoryboardName.home]
        NotificationCenter.default.post(name: .setRootVC, object: nil, userInfo: userInfo)
    }
    
    func routeToLogin() {
        let userInfo = [SharedConstants.Key.storyboardName: SharedConstants.StoryboardName.login]
        NotificationCenter.default.post(name: .setRootVC, object: nil, userInfo: userInfo)
    }
}
