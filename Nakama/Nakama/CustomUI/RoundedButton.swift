//
//  NakamaButton.swift
//  Nakama
//
//  Created by Yew Joon Wong on 23/08/2022.
//

import UIKit

@IBDesignable class RoundedButton: UIButton {
    
    // MARK: - Variables
    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderColor: UIColor = .black {
        didSet {
            setNeedsLayout()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            let alpha: CGFloat = isEnabled ? 1.0 : 0.5
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(alpha)
        }
    }
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let alpha: CGFloat = isEnabled ? 1.0 : 0.5
        self.backgroundColor = self.backgroundColor?.withAlphaComponent(alpha)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}
