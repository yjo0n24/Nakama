//
//  RoundedImageView.swift
//  Nakama
//
//  Created by Yew Joon Wong on 31/08/2022.
//

import UIKit

@IBDesignable class RoundedImageView: UIImageView {
    
    // MARK: - Variables
    @IBInspectable var isCircleView: Bool = false {
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
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isCircleView {
            self.layer.cornerRadius = self.bounds.height / 2
        } else {
            self.layer.cornerRadius = 10.0
        }
        self.clipsToBounds = true
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}
