//
//  BaseUIViewController.swift
//  Nakama
//
//  Created by Yew Joon Wong on 29/08/2022.
//

import UIKit
import IQKeyboardManagerSwift
import Lottie

class BaseUIViewController: UIViewController {
    
    // MARK: - Variables
    private var loadingAlertView: UIAlertController?
    
    // MARK: - UI Methods
    func setKeyboardManager(isEnabled: Bool) {
        IQKeyboardManager.shared.enable = isEnabled
    }
    
    private func setupLoadingIndicator() {
        loadingAlertView = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let loadingView = AnimationView(name: "lottie-loading")
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.contentMode = .scaleAspectFit
        loadingView.loopMode = .loop
        loadingView.animationSpeed = 1.0
        loadingView.play()
        loadingAlertView?.view.addSubview(loadingView)
        
        // Constraints
        let cstCenterX = NSLayoutConstraint(item: loadingView, attribute: .centerX, relatedBy: .equal,
                                            toItem: loadingAlertView?.view, attribute: .centerX, multiplier: 1, constant: 0)
        let cstCenterY = NSLayoutConstraint(item: loadingView, attribute: .centerY, relatedBy: .equal,
                                            toItem: loadingAlertView?.view, attribute: .centerY, multiplier: 1, constant: 0)
        let cstTopMargin = NSLayoutConstraint(item: loadingView, attribute: .topMargin, relatedBy: .equal,
                                              toItem: loadingAlertView?.view, attribute: .top, multiplier: 1, constant: 15)
        let cstBtmMargin = NSLayoutConstraint(item: loadingView, attribute: .bottomMargin, relatedBy: .equal,
                                              toItem: loadingAlertView?.view, attribute: .bottom, multiplier: 1, constant: 15)
        let cstLeadMargin = NSLayoutConstraint(item: loadingView, attribute: .leadingMargin, relatedBy: .equal,
                                               toItem: loadingAlertView?.view, attribute: .leadingMargin, multiplier: 1, constant: 15)
        let cstTrailMargin = NSLayoutConstraint(item: loadingView, attribute: .trailingMargin, relatedBy: .equal,
                                               toItem: loadingAlertView?.view, attribute: .trailing, multiplier: 1, constant: 15)
        
        NSLayoutConstraint.activate([cstCenterX, cstCenterY, cstTopMargin, cstBtmMargin, cstLeadMargin, cstTrailMargin])
    }
    
    func showLoadingIndicator() {
        if loadingAlertView == nil {
            setupLoadingIndicator()
        }
        self.present(loadingAlertView!, animated: true)
    }
    
    func dismissLoadingIndicator() {
        loadingAlertView?.dismiss(animated: true)
    }
    
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
    
    // MARK: - Routing Methods
    func routeToHome() {
        let userInfo = [SharedConstants.Key.storyboardName: SharedConstants.StoryboardName.home]
        NotificationCenter.default.post(name: .setRootVC, object: nil, userInfo: userInfo)
    }
    
    func routeToLogin() {
        let userInfo = [SharedConstants.Key.storyboardName: SharedConstants.StoryboardName.login]
        NotificationCenter.default.post(name: .setRootVC, object: nil, userInfo: userInfo)
    }
}
