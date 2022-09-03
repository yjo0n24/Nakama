//
//  LoginVC.swift
//  Nakama
//
//  Created by Yew Joon Wong on 24/08/2022.
//

import UIKit

class LoginVC: BaseUIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailView: UIStackView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: RoundedButton!
    
    // MARK: - Variables
    private let presenter: LoginPresenter = LoginPresenter(service: LoginService())
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        initUI()
    }
    
    private func initUI() {
        txtEmail.addTarget(self, action: #selector(validateSignIn), for: .editingChanged)
        txtPassword.addTarget(self, action: #selector(validateSignIn), for: .editingChanged)
    }
    
    @objc private func validateSignIn() {
        presenter.validateInput(txtEmail.text!, txtPassword.text!)
    }
    
    // MARK: - IBActions
    @IBAction func btnSignInAction(_ sender: UIButton) {
        presenter.performSignIn(email: txtEmail.text!, password: txtPassword.text!)
    }
    
    @IBAction func btnGoogleSignInAction(_ sender: UIButton) {
        
    }
    
    @IBAction func btnAppleSignInAction(_ sender: UIButton) {
        
    }
}

// MARK: - LoginPresenterProtocol
extension LoginVC: LoginPresenterProtocol {
    
    // Form validation
    func onFormValidate(isValid: Bool) {
        btnSignIn.isEnabled = isValid
    }
    
    func showEmailFormatError(errorMessage: String) {
        lblEmailError.text = errorMessage
        lblEmailError.isHidden = false
    }
    
    func hideEmailFormatError() {
        lblEmailError.isHidden = true
    }
    
    // Service callback
    func onSignInSuccess() {
        routeToHome()
    }
    
    func onError(errorMessage: String) {
        showAlert(message: errorMessage)
    }
}
