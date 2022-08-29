//
//  ProfileVC.swift
//  Nakama
//
//  Created by Yew Joon Wong on 28/08/2022.
//

import UIKit

class ProfileVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var btnProfile: RoundedButton!
    @IBOutlet weak var tblTimeline: UITableView!
    @IBOutlet weak var cstImgBannerHeight: NSLayoutConstraint!
    @IBOutlet weak var cstTblTimelineHeight: NSLayoutConstraint!
    
    // MARK: - Variables
    private let cellIdentifier = String(describing: TimelinePostCell.self)
    private var oriBannerHeight: CGFloat = 0
    private var minBannerHeight: CGFloat = 0
    private var previousScrollOffsetY: CGFloat = 0
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        registerCells()
        initUI()
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
        
        if keyPath == SharedConstants.Key.contentSize {
            guard let contentSize = change?[.newKey] as? CGSize else { return }
            cstTblTimelineHeight.constant = contentSize.height
        }
    }
    
    private func initObservers() {
        tblTimeline.addObserver(self, forKeyPath: SharedConstants.Key.contentSize, options: [.new], context: nil)
    }
    
    private func registerCells() {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tblTimeline.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func initUI() {
        oriBannerHeight = 0.25 * UIScreen.main.bounds.height
        minBannerHeight = 0.1 * UIScreen.main.bounds.height
        cstImgBannerHeight.constant = oriBannerHeight
    }
}

// MARK: - UIScrollViewDelegate
extension ProfileVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("offsetY: \(scrollView.contentOffset.y)")
        let offsetDiff = previousScrollOffsetY - scrollView.contentOffset.y
        previousScrollOffsetY = offsetDiff
        
        var newHeight = cstImgBannerHeight.constant + offsetDiff
        
        if newHeight < minBannerHeight {
            newHeight = minBannerHeight
        } else if newHeight > oriBannerHeight {
            newHeight = oriBannerHeight
        }
        
        cstImgBannerHeight.constant = newHeight
        self.view.layoutIfNeeded()
    }
}

// MARK: - UITableViewDelegate
extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        let lblHeader = UILabel(frame: CGRect(x: 25, y: 0, width: tableView.bounds.width, height: 50))
        lblHeader.text = StringConstants.Profile.lblPostsHeader.localized
        lblHeader.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        headerView.addSubview(lblHeader)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TimelinePostCell
        return cell
    }
}
