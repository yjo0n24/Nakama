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
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var imageSelectionView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var btnNext: RoundedButton!
    
    // MARK: - Variables
    private let presenter: RegistrationPresenter = RegistrationPresenter()
    var stepType: RegistrationStepType = .username
    var username: String = ""
    var profileImage: String?
    
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
            txtEmail.isHidden = true
            txtPassword.isHidden = true
            txtConfirmPassword.isHidden = true
            txtUsername.placeholder = StringConstants.Registration.txtPlaceholderUsername.localized
            txtUsername.addTarget(self, action: #selector(validateField), for: .editingChanged)
            
            imageSelectionView.isHidden = true
            
            btnNext.isEnabled = false
            btnNext.setTitle(StringConstants.General.btnNext.localized, for: .normal)
            
        case .image:
            lblTitle.text = StringConstants.Registration.lblStep2Title.localized
            lblDescription.text = StringConstants.Registration.lblStep2Desc.localized
            
            txtUsername.isHidden = true
            txtEmail.isHidden = true
            txtPassword.isHidden = true
            txtConfirmPassword.isHidden = true
            
            imageSelectionView.isHidden = false
            
            btnNext.isEnabled = true
            btnNext.setTitle(StringConstants.General.btnLater.localized, for: .normal)
            
        case .credentials:
            lblTitle.text = StringConstants.Registration.lblStep3Title.localized
            lblDescription.text = StringConstants.Registration.lblStep3Desc.localized
            
            txtUsername.isHidden = true
            txtEmail.isHidden = false
            txtPassword.isHidden = false
            txtConfirmPassword.isHidden = false
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
            //registrationVC.stepType = stepType == .username ? .image : .credentials
            
            if stepType == .username {
                registrationVC.stepType = .image
                registrationVC.username = txtUsername.text!
            } else if stepType == .image {
                registrationVC.stepType = .credentials
                registrationVC.username = username
                registrationVC.profileImage = profileImage
            }
            
            self.navigationController?.pushViewController(registrationVC, animated: true)
            
        } else {
            presenter.performSignUp(username: username,
                                  email: txtEmail.text!,
                                  password: txtPassword.text!,
                                  profileImage: profileImage)
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
    
    func didValidateInput(isValid: Bool) {
        btnNext.isEnabled = isValid
    }
    
    func onSignUpSuccess() {
        routeToHome()
    }
    
    func onError(errorMessage: String) {
        showAlert(message: errorMessage)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension RegistrationVC: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        provider.loadObject(ofClass: UIImage.self, completionHandler: { [weak self] (image, error) in
            if let selectedImage = image as? UIImage {
                DispatchQueue.main.async {
                    self?.imageView.image = selectedImage
                    self?.btnNext.setTitle(StringConstants.General.btnNext.localized, for: .normal)
                }
            }
        })
    }
}
