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
    
    private func setTextAttachment(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        let scaleFactor = image.size.width / (txtContent.frame.size.width - 10)
        let scaledImage = UIImage(cgImage: cgImage, scale: scaleFactor, orientation: .up)
        
        let attachment = NSTextAttachment()
        attachment.image = scaledImage
        let attrString = NSAttributedString(attachment: attachment)
        let oriTextPos = txtContent.selectedRange.location
        
        txtContent.text = txtContent.text + "\n\n"
        txtContent.textStorage.insert(attrString, at: txtContent.selectedRange.location)
        txtContent.selectedRange = NSRange(location: oriTextPos, length: 0)
    }
    
    private func removeTextAttachment() -> String {
        var newText = txtContent.text ?? ""
        
        let enumRange = NSRange(location: 0, length: txtContent.attributedText.length)
        txtContent.attributedText.enumerateAttribute(.attachment, in: enumRange, using: { (value, range, stop) in
            if let attachment = value as? NSTextAttachment, attachment.image != nil {
                guard let mutableAttrStr = txtContent.attributedText.mutableCopy() as? NSMutableAttributedString else {
                    return
                }
                mutableAttrStr.replaceCharacters(in: range, with: "")
                newText = mutableAttrStr.string
            }
        })
        
        return newText
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnUploadImageAction(_ sender: UIButton) {
        showImagePicker()
    }
    
    @IBAction func btnPostAction(_ sender: UIButton) {
        // Remove attachment from text before posting
        let textContent = removeTextAttachment()
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
    
    func textViewDidChange(_ textView: UITextView) {
        lblTextCount.text = "\(textView.text.count)/500"
        presenter.validateInput(textView.text!)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension PostEditorVC: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        provider.loadObject(ofClass: UIImage.self, completionHandler: { [weak self] (image, error) in
            if let selectedImage = image as? UIImage {
                DispatchQueue.main.async {
                    self?.imageData = selectedImage.jpegData(compressionQuality: 0.8)
                    self?.setTextAttachment(selectedImage)
                }
            }
        })
    }
}
