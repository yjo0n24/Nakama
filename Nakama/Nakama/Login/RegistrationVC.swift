//
//  RegistrationVC.swift
//  Nakama
//
//  Created by Yew Joon Wong on 24/08/2022.
//

import UIKit

class RegistrationVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var txtInputField: UITextField!
    @IBOutlet weak var txtInputField2: UITextField!
    @IBOutlet weak var btnNext: RoundedButton!
    
    // MARK: - Variables
    private let presenter: RegistrationPresenter = RegistrationPresenter()
    var stepType: RegistrationStepType = .username
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        initUI()
    }
    
    private func initUI() {
        switch stepType {
        case .username:
            lblTitle.text = StringConstants.Registration.lblStep1Title.localized
            lblDescription.text = StringConstants.Registration.lblStep1Desc.localized
            txtInputField.placeholder = StringConstants.Registration.txtPlaceholderUsername.localized
            txtInputField2.isHidden = true
            btnNext.setTitle(StringConstants.General.btnNext.localized, for: .normal)
            
        case .email:
            lblTitle.text = StringConstants.Registration.lblStep2Title.localized
            lblDescription.text = StringConstants.Registration.lblStep2Desc.localized
            txtInputField.placeholder = StringConstants.Registration.txtPlaceholderEmail.localized
            txtInputField2.isHidden = true
            btnNext.setTitle(StringConstants.General.btnNext.localized, for: .normal)
            
        case .password:
            lblTitle.text = StringConstants.Registration.lblStep3Title.localized
            lblDescription.text = StringConstants.Registration.lblStep3Desc.localized
            txtInputField.placeholder = StringConstants.Registration.txtPlaceholderPassword.localized
            txtInputField.isSecureTextEntry = true
            txtInputField2.placeholder = StringConstants.Registration.txtPlaceholderConfirmPassword.localized
            txtInputField2.isHidden = false
            txtInputField2.isSecureTextEntry = true
            btnNext.setTitle(StringConstants.Registration.btnFinish.localized, for: .normal)
        }
        
        txtInputField.addTarget(self, action: #selector(validateField), for: .editingChanged)
    }
    
    @objc private func validateField() {
        presenter.validateInput(txtInputField.text!, txtInputField2.text!, stepType: stepType)
    }
    
    // MARK: - IBActions
    @IBAction func btnNextAction(_ sender: UIButton) {
        if stepType != .password {
            let vc = UIStoryboard(
                name: SharedConstants.StoryboardName.login,
                bundle: nil
            ).instantiateViewController(withIdentifier: SharedConstants.StoryboardId.registrationVC)
            
            guard let registrationVC = vc as? RegistrationVC else { return }
            registrationVC.stepType = stepType == .username ? .email : .password
            
            self.navigationController?.pushViewController(registrationVC, animated: true)
            
        } else {
            
        }
    }
}

// MARK: - RegistrationPresenterProtocol
extension RegistrationVC: RegistrationPresenterProtocol {
    
    func didValidateInput(isValid: Bool) {
        btnNext.isEnabled = isValid
    }
}
