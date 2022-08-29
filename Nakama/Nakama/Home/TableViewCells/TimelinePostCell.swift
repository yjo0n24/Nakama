//
//  TimelinePostCell.swift
//  Nakama
//
//  Created by Yew Joon Wong on 27/08/2022.
//

import UIKit

class TimelinePostCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var txtContent: UITextView!
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func initUI() {
        self.selectionStyle = .none
        imgUser.layer.cornerRadius = imgUser.bounds.height / 2
        txtContent.textContainerInset = .zero
        txtContent.textContainer.lineFragmentPadding = 0
    }
}
