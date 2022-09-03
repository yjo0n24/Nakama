//
//  PostEditorVC.swift
//  Nakama
//
//  Created by Yew Joon Wong on 31/08/2022.
//

import UIKit
import Photos
import PhotosUI

class PostEditorVC: BaseUIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var lblTextCount: UILabel!
    @IBOutlet weak var txtContent: UITextView!
    @IBOutlet weak var imgAttachment: UIImageView!
    @IBOutlet weak var btnUploadImage: UIButton!
    @IBOutlet weak var btnPost: RoundedButton!
    
    // MARK: - Variables
    private let presenter = PostEditorPresenter()
    private var imageData: Data?
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        initUI()
    }
    
    private func initUI() {
        txtContent.text = StringConstants.PostEditor.txtPlaceholder.localized
        txtContent.textColor = .lightGray
        imgAttachment.layer.cornerRadius = 10.0
        btnUploadImage.imageView?.contentMode = .scaleAspectFit
    }
    
    private func showImagePicker() {
        var pickerConfig = PHPickerConfiguration()
        pickerConfig.selectionLimit = 1
        pickerConfig.filter = .images
        
        let picker = PHPickerViewController(configuration: pickerConfig)
        
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    private func attachImage(selectedImage: UIImage) {
        imageData = selectedImage.jpegData(compressionQuality: 0.8)
        imgAttachment.image = selectedImage
        imgAttachment.isHidden = false
        presenter.validateInput(txtContent.text ?? "", imageData: imageData)
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnUploadImageAction(_ sender: UIButton) {
        showImagePicker()
    }
    
    @IBAction func btnPostAction(_ sender: UIButton) {
        var textContent = txtContent.text ?? ""
        if txtContent.textColor == .lightGray {
            textContent = ""
        }
        presenter.performCreatePost(textContent: textContent, imageData: imageData)
    }
}

// MARK: - PostEditorPresenterProtocol
extension PostEditorVC: PostEditorPresenterProtocol {
    
    func didValidateInput(isValid: Bool) {
        btnPost.isEnabled = isValid
    }
    
    func onCreatePostSuccess() {
        self.dismiss(animated: true)
    }
    
    func onError(errorMessage: String) {
        showAlert(message: errorMessage)
    }
}

// MARK: - UITextViewDelegate
extension PostEditorVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        lblTextCount.text = "\(textView.text.count)/500"
        presenter.validateInput(textView.text ?? "", imageData: imageData)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = StringConstants.PostEditor.txtPlaceholder.localized
            textView.textColor = .lightGray
        }
    }
}

// MARK: - PHPickerViewControllerDelegate
extension PostEditorVC: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider else {
            return
        }
        
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self, completionHandler: { [weak self] (image, error) in
                if let selectedImage = image as? UIImage {
                    DispatchQueue.main.async {
                        self?.attachImage(selectedImage: selectedImage)
                    }
                }
            })
        } else {
            provider.loadDataRepresentation(forTypeIdentifier: "public.image", completionHandler: { [weak self] (data, error) in
                if let data = data, let selectedImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.attachImage(selectedImage: selectedImage)
                    }
                }
            })
        }
    }
}
