//
//  LoginVC.swift
//  Nakama
//
//  Created by Yew Joon Wong on 24/08/2022.
//

import UIKit

class LoginVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: RoundedButton!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    private func initUI() {
        txtEmail.addTarget(self, action: #selector(validateSignIn), for: .editingChanged)
        txtPassword.addTarget(self, action: #selector(validateSignIn), for: .editingChanged)
    }
    
    @objc private func validateSignIn() {
        if !txtEmail.text!.isEmpty && !txtPassword.text!.isEmpty {
            btnSignIn.isEnabled = true
        } else {
            btnSignIn.isEnabled = false
        }
    }
    
    // MARK: - IBActions
    @IBAction func btnSignInAction(_ sender: UIButton) {
        
    }
    
    @IBAction func btnGoogleSignInAction(_ sender: UIButton) {
        
    }
    
    @IBAction func btnAppleSignInAction(_ sender: UIButton) {
        
    }
}
