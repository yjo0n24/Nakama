//
//  TimelineVC.swift
//  Nakama
//
//  Created by Yew Joon Wong on 27/08/2022.
//

import UIKit
import Kingfisher
import iOSDropDown

class HomeVC: BaseUIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblTimeline: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var btnCreatePost: UIButton!
    
    // MARK: - Variables
    private let refreshControl = UIRefreshControl()
    private let presenter = HomePresenter()
    private let cellIdentifier = String(describing: TimelinePostCell.self)
    private var rowCount = 0
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        registerCells()
        presenter.delegate = self
        presenter.performGetPublicPosts(refreshPosts: true)
    }
    
    private func initUI() {
        refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        tblTimeline.refreshControl = refreshControl
    }
    
    private func registerCells() {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tblTimeline.register(nib, forCellReuseIdentifier: cellIdentifier)
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
    
    @objc private func refreshPosts() {
        presenter.performGetPublicPosts(refreshPosts: true)
    }
    
    // MARK: - IBActions
    @IBAction func btnRefreshAction(_ sender: UIButton) {
        refreshPosts()
    }
    
    @IBAction func btnCreatePostAction(_ sender: UIButton) {
        let postEditorVC = PostEditorVC(nibName: String(describing: PostEditorVC.self), bundle: nil)
        self.present(postEditorVC, animated: true)
    }
}

// MARK: - HomePresenterProtocol
extension HomeVC: HomePresenterProtocol {
    
    func didReceivePosts(numOfRows: Int, refreshTableView: Bool) {
        rowCount = numOfRows

        if rowCount > 0 {
            shouldShowEmptyView(false)
            
            if refreshTableView {
                refreshControl.endRefreshing()
                tblTimeline.reloadData()
            } else {
                UIView.performWithoutAnimation {
                    let currentOffset = tblTimeline.contentOffset
                    tblTimeline.reloadData()
                    tblTimeline.contentOffset = currentOffset
                }
            }
        } else {
            shouldShowEmptyView(true)
        }
    }
    
    func didReachEndOfPosts() {
        rowCount > 0 ? shouldShowEmptyView(false) : shouldShowEmptyView(true)
        
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    func onError(errorMessage: String) {
        showAlert(message: errorMessage)
        
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDelegate
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
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
            moreHidden: true
        )
        
        return cell
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension HomeVC: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let newRows = indexPaths.filter({ $0.row >= (rowCount - 1) })
        if newRows.count > 0 {
            rowCount += 1
        }

        newRows.forEach({ _ in
            presenter.performGetPublicPosts(refreshPosts: false, numOfPosts: 1)
        })
    }
}
