//
//  TimelinePostCell.swift
//  Nakama
//
//  Created by Yew Joon Wong on 27/08/2022.
//

import UIKit
import Kingfisher

class TimelinePostCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imgUser: RoundedImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var txtContent: UITextView!
    @IBOutlet weak var imgContent: UIImageView!
    @IBOutlet weak var btnMore: UIButton!
    
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
        txtContent.textContainerInset = .zero
        txtContent.textContainer.lineFragmentPadding = 0
    }
    
    private func setImage(for imageView: UIImageView, url: URL, placeholder: UIImage) {
        let imgProcessor = DownsamplingImageProcessor(size: imageView.bounds.size) |> RoundCornerImageProcessor(cornerRadius: 10)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .processor(imgProcessor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
           ],
           completionHandler: { _ in }
        )
    }
    
    func setupCell(username: String, userImage: String?, textContent: String, imageUrl: String?, createdDate: String, moreHidden: Bool) {
        let usernameAndTime = NSMutableAttributedString(string: "\(username)  \u{2022} \(createdDate)")
        let formattedUsernameAndTime = usernameAndTime
            .colour(text: createdDate, .lightGray)
            .font(text: createdDate, .systemFont(ofSize: 12.0, weight: .regular))
        lblUsername.attributedText = formattedUsernameAndTime
        
        txtContent.text = textContent
        
        // User profile image
        if let imageDownloadUrl = URL(string: userImage ?? "") {
            setImage(for: imgUser, url: imageDownloadUrl, placeholder: UIImage(named: "profile-image") ?? UIImage())
        } else {
            imgUser.image = UIImage(named: "profile-image")
        }
        
        // Post image
        if let imageDownloadUrl = URL(string: imageUrl ?? "") {
            setImage(for: imgContent, url: imageDownloadUrl, placeholder: UIImage(named: "photo-placeholder") ?? UIImage())
            imgContent.isHidden = false
        } else {
            imgContent.image = nil
            imgContent.isHidden = true
        }
        
        btnMore.isHidden = moreHidden
    }
}
