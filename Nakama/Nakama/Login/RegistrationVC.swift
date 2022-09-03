//
//  RegistrationVC.swift
//  Nakama
//
//  Created by Yew Joon Wong on 24/08/2022.
//

import UIKit
import Photos
import PhotosUI

class RegistrationVC: BaseUIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var emailView: UIStackView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var passwordView: UIStackView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblPasswordError: UILabel!
    @IBOutlet weak var confirmPasswordView: UIStackView!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var lblConfirmPasswordError: UILabel!
    @IBOutlet weak var imageSelectionView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var btnNext: RoundedButton!
    
    // MARK: - Variables
    var presenter: RegistrationPresenter = RegistrationPresenter(service: RegistrationService())
    var stepType: RegistrationStepType = .username
    var username: String = ""
    private var imageData: Data?
    
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
            
            txtUsername.isHidden = false
            emailView.isHidden = true
            passwordView.isHidden = true
            confirmPasswordView.isHidden = true
            txtUsername.placeholder = StringConstants.Registration.txtPlaceholderUsername.localized
            txtUsername.addTarget(self, action: #selector(validateField), for: .editingChanged)
            
            imageSelectionView.isHidden = true
            
            btnNext.isEnabled = false
            btnNext.setTitle(StringConstants.General.btnNext.localized, for: .normal)
            
        case .image:
            lblTitle.text = StringConstants.Registration.lblStep2Title.localized
            lblDescription.text = StringConstants.Registration.lblStep2Desc.localized
            
            txtUsername.isHidden = true
            emailView.isHidden = true
            passwordView.isHidden = true
            confirmPasswordView.isHidden = true
            
            imageSelectionView.isHidden = false
            
            btnNext.isEnabled = true
            btnNext.setTitle(StringConstants.General.btnLater.localized, for: .normal)
            
        case .credentials:
            lblTitle.text = StringConstants.Registration.lblStep3Title.localized
            lblDescription.text = StringConstants.Registration.lblStep3Desc.localized
            
            txtUsername.isHidden = true
            emailView.isHidden = false
            passwordView.isHidden = false
            confirmPasswordView.isHidden = false
            txtEmail.placeholder = StringConstants.Registration.txtPlaceholderEmail.localized
            txtPassword.placeholder = StringConstants.Registration.txtPlaceholderPassword.localized
            txtConfirmPassword.placeholder = StringConstants.Registration.txtPlaceholderConfirmPassword.localized
            txtEmail.addTarget(self, action: #selector(validateField), for: .editingChanged)
            txtPassword.addTarget(self, action: #selector(validateField), for: .editingChanged)
            txtConfirmPassword.addTarget(self, action: #selector(validateField), for: .editingChanged)
            
            imageSelectionView.isHidden = true
            
            btnNext.isEnabled = false
            btnNext.setTitle(StringConstants.Registration.btnFinish.localized, for: .normal)
        }
    }
    
    private func showFieldErrors(for errorTypes: [FormErrorType]) {
        if errorTypes.contains(.emailInvalid) {
            lblEmailError.text = StringConstants.Registration.lblInvalidEmailError.localized
            lblEmailError.isHidden = false
        } else {
            lblEmailError.isHidden = true
        }
        
        if errorTypes.contains(.passwordInvalid) {
            lblPasswordError.text = StringConstants.Registration.lblInvalidPasswordError.localized
            lblPasswordError.isHidden = false
        } else {
            if errorTypes.contains(.passwordMismatch) {
                lblPasswordError.text = StringConstants.Registration.lblPasswordMismatchError.localized
                lblConfirmPasswordError.text = StringConstants.Registration.lblPasswordMismatchError.localized
                lblPasswordError.isHidden = false
                lblConfirmPasswordError.isHidden = false
            } else {
                lblPasswordError.isHidden = true
                lblConfirmPasswordError.isHidden = true
            }
        }
    }
    
    private func hideAllFieldErrors() {
        lblEmailError.isHidden = true
        lblPasswordError.isHidden = true
        lblConfirmPasswordError.isHidden = true
    }
    
    private func showImagePicker() {
        var pickerConfig = PHPickerConfiguration()
        pickerConfig.selectionLimit = 1
        pickerConfig.filter = .images
        
        let picker = PHPickerViewController(configuration: pickerConfig)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    private func routeToNextStep() {
        if stepType != .credentials {
            let vc = UIStoryboard(
                name: SharedConstants.StoryboardName.login,
                bundle: nil
            ).instantiateViewController(withIdentifier: SharedConstants.StoryboardId.registrationVC)
            
            guard let registrationVC = vc as? RegistrationVC else { return }
            
            if stepType == .username {
                registrationVC.stepType = .image
                registrationVC.username = txtUsername.text!
            } else if stepType == .image {
                registrationVC.stepType = .credentials
                registrationVC.username = username
                registrationVC.imageData = imageData
            }
            
            self.navigationController?.pushViewController(registrationVC, animated: true)
            
        } else {
            presenter.performSignUp(
                username: username,
                email: txtEmail.text!,
                password: txtPassword.text!,
                imageData: imageData
            )
        }
    }
    
    @objc private func validateField() {
        if stepType == .username {
            presenter.validateUsername(txtUsername.text!)
        } else if stepType == .credentials {
            presenter.validateCredentials(email: txtEmail.text!,
                                        password: txtPassword.text!,
                                        confirmPassword: txtConfirmPassword.text!)
        }
    }
    
    // MARK: - IBActions
    @IBAction func btnSelectImageAction(_ sender: UIButton) {
        showImagePicker()
    }
    
    @IBAction func btnNextAction(_ sender: UIButton) {
        routeToNextStep()
    }
}

// MARK: - RegistrationPresenterProtocol
extension RegistrationVC: RegistrationPresenterProtocol {
    
    func onFormValidate(isValid: Bool) {
        hideAllFieldErrors()
        btnNext.isEnabled = isValid
    }
    
    func onSignUpSuccess() {
        routeToHome()
    }
    
    func onError(errorMessage: String) {
        showAlert(message: errorMessage)
    }
    
    func onErrorValidateCredentials(errorTypes: [FormErrorType]) {
        showFieldErrors(for: errorTypes)
        btnNext.isEnabled = false
    }
}

// MARK: - PHPickerViewControllerDelegate
extension RegistrationVC: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider else {
            return
        }
        
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self, completionHandler: { [weak self] (image, error) in
                if let selectedImage = image as? UIImage {
                    DispatchQueue.main.async {
                        self?.imageView.image = selectedImage
                        self?.imageData = selectedImage.jpegData(compressionQuality: 0.8)
                        self?.btnNext.setTitle(StringConstants.General.btnNext.localized, for: .normal)
                    }
                }
            })
        } else {
            provider.loadDataRepresentation(forTypeIdentifier: "public.image", completionHandler: { [weak self] (data, error) in
                if let data = data, let selectedImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = selectedImage
                        self?.imageData = selectedImage.jpegData(compressionQuality: 0.8)
                        self?.btnNext.setTitle(StringConstants.General.btnNext.localized, for: .normal)
                    }
                }
            })
        }
    }
}
