//
//  ProfileVC.swift
//  Nakama
//
//  Created by Yew Joon Wong on 28/08/2022.
//

import UIKit
import Kingfisher

class ProfileVC: BaseUIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var imgProfile: RoundedImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var tblTimeline: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var btnCreatePost: UIButton!
    @IBOutlet weak var cstHeaderViewHeight: NSLayoutConstraint!
    
    // MARK: - Variables
    private let refreshControl = UIRefreshControl()
    private let presenter = ProfilePresenter(service: ProfileService())
    private let cellIdentifier = String(describing: TimelinePostCell.self)
    private var rowCount = 0
    private var oriHeaderHeight: CGFloat = 0.0
    private var headerStretchLimit: CGFloat = 0.0
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        registerCells()
        presenter.delegate = self
        presenter.performGetPersonalPosts(refreshPosts: true)
    }
    
    private func registerCells() {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tblTimeline.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func initUI() {
        cstHeaderViewHeight.constant = 0.25 * UIScreen.main.bounds.height
        oriHeaderHeight = cstHeaderViewHeight.constant
        headerStretchLimit = (0.1 * oriHeaderHeight) + oriHeaderHeight
        refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        tblTimeline.refreshControl = refreshControl
        
        lblUsername.text = presenter.getUsername()
        
        if let profileImageUrl = presenter.getUserProfileImageUrl() {
            setProfileImage(with: profileImageUrl)
        }
    }
    
    private func setProfileImage(with url: URL) {
        let imgProcessor = DownsamplingImageProcessor(size: imgProfile.bounds.size) |> RoundCornerImageProcessor(cornerRadius: 10)
        imgProfile.kf.indicatorType = .activity
        imgProfile.kf.setImage(
            with: url,
            placeholder: UIImage(named: "profile-image"),
            options: [
                .processor(imgProcessor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
           ],
           completionHandler: { _ in }
        )
    }
    
    private func animateHeader() {
        cstHeaderViewHeight.constant = oriHeaderHeight
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: .curveEaseInOut,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    private func shouldShowEmptyView(_ showEmptyView: Bool) {
        if showEmptyView {
            emptyView.isHidden = false
            view.bringSubviewToFront(emptyView)
        } else {
            emptyView.isHidden = true
            view.sendSubviewToBack(emptyView)
        }
        
        view.bringSubviewToFront(btnCreatePost)
    }
    
    private func showDeletePostConfirmation(postIndex: Int) {
        showAlert(title: StringConstants.Profile.alertDeletePostTitle.localized,
                  message: StringConstants.Profile.alertDeletePostMsg.localized,
                  actionTitle: StringConstants.General.btnContinue.localized,
                  completion: { [weak self] action in
            
            if action.style == .destructive {
                self?.showLoadingIndicator()
                self?.presenter.performDeletePost(postAt: postIndex)
            }
        })
    }
    
    @objc private func refreshPosts() {
        self.presenter.performGetPersonalPosts(refreshPosts: true)
    }
    
    @objc private func cellBtnMoreAction(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: StringConstants.General.btnDelete.localized,
                                          style: .destructive,
                                          handler: { [weak self] action in
            
            self?.showDeletePostConfirmation(postIndex: sender.tag)
        }))
        
        actionSheet.addAction(UIAlertAction(title: StringConstants.General.btnCancel.localized, style: .cancel))
        self.present(actionSheet, animated: true)
    }
    
    // MARK: - IBActions
    @IBAction func btnSettingsAction(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: StringConstants.Profile.btnLogout.localized,
                                          style: .destructive,
                                          handler: { [weak self] action in
            
            self?.showLoadingIndicator()
            self?.presenter.performLogout()
        }))
        
        actionSheet.addAction(UIAlertAction(title: StringConstants.General.btnCancel.localized, style: .cancel))
        self.present(actionSheet, animated: true)
    }
    
    @IBAction func btnRefreshAction(_ sender: UIButton) {
        refreshPosts()
    }
    
    @IBAction func btnCreatePostAction(_ sender: UIButton) {
        let postEditorVC = PostEditorVC(nibName: String(describing: PostEditorVC.self), bundle: nil)
        self.present(postEditorVC, animated: true)
    }
}

// MARK: - ProfilePresenterProtocol
extension ProfileVC: ProfilePresenterProtocol {
    
    func didReceivePosts(numOfRows: Int, refreshTableView: Bool) {
        DispatchQueue.main.async {
            self.rowCount = numOfRows

            if self.rowCount > 0 {
                self.shouldShowEmptyView(false)
                
                if refreshTableView {
                    self.refreshControl.endRefreshing()
                    self.tblTimeline.reloadData()
                } else {

                    UIView.performWithoutAnimation {
                        let currentOffset = self.tblTimeline.contentOffset
                        self.tblTimeline.reloadData()
                        self.tblTimeline.contentOffset = currentOffset
                    }
                }
            } else {
                self.shouldShowEmptyView(true)
            }
        }
    }
    
    func didReachEndOfPosts() {
        DispatchQueue.main.async {
            self.rowCount > 0 ? self.shouldShowEmptyView(false) : self.shouldShowEmptyView(true)
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func onPostDeleteSuccess(message: String) {
        DispatchQueue.main.async {
            self.dismissLoadingIndicator()
            self.showAlert(title: StringConstants.Profile.alertDeletePostSuccessTitle.localized, message: message)
        }
    }
    
    func onLogoutSuccess() {
        DispatchQueue.main.async {
            self.dismissLoadingIndicator()
            self.routeToLogin()
        }
    }
    
    func onError(errorMessage: String) {
        DispatchQueue.main.async {
            self.dismissLoadingIndicator()
            self.showAlert(message: errorMessage)
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ProfileVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y < 0 && cstHeaderViewHeight.constant < headerStretchLimit {
//            cstHeaderViewHeight.constant += abs(scrollView.contentOffset.y)
//        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if cstHeaderViewHeight.constant > oriHeaderHeight {
            animateHeader()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if cstHeaderViewHeight.constant > oriHeaderHeight {
            animateHeader()
        }
    }
}

// MARK: - UITableViewDelegate
extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        headerView.backgroundColor = .white
        let lblHeader = UILabel(frame: CGRect(x: 25, y: 0, width: tableView.bounds.width, height: 50))
        lblHeader.text = StringConstants.Profile.lblPostsHeader.localized
        lblHeader.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        headerView.addSubview(lblHeader)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TimelinePostCell
        
        let displayData = presenter.getPostDisplayData(with: indexPath.row)
        cell.setupCell(
            username: displayData.username,
            userImage: displayData.userImage,
            textContent: displayData.textContent,
            imageUrl: displayData.imageUrl,
            createdDate: displayData.createdDate,
            moreHidden: false
        )
        cell.btnMore.tag = indexPath.row
        cell.btnMore.addTarget(self, action: #selector(cellBtnMoreAction(_:)), for: .touchUpInside)
        
        return cell
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension ProfileVC: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let newRows = indexPaths.filter({ $0.row >= (rowCount - 1) })
        if newRows.count > 0 {
            rowCount += 1
        }

        newRows.forEach({ _ in
            presenter.performGetPersonalPosts(refreshPosts: false, numOfPosts: 1)
        })
    }
}
