//
//  TimelineVC.swift
//  Nakama
//
//  Created by Yew Joon Wong on 27/08/2022.
//

import UIKit

class HomeVC: BaseUIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblTimeline: UITableView!
    
    // MARK: - Variables
    private let presenter = HomePresenter()
    private let cellIdentifier = String(describing: TimelinePostCell.self)
    private var rowCount = 0
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        presenter.delegate = self
        presenter.performGetPublicPosts()
    }
    
    private func registerCells() {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tblTimeline.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    @IBAction func btnCreatePostAction(_ sender: UIButton) {
        let postEditorVC = PostEditorVC(nibName: String(describing: PostEditorVC.self), bundle: nil)
        self.present(postEditorVC, animated: true)
    }
}

// MARK: - HomePresenterProtocol
extension HomeVC: HomePresenterProtocol {
    func reloadData(numOfRows: Int) {
        rowCount = numOfRows
        tblTimeline.reloadData()
    }
    
    func onError(errorMessage: String) {
        showAlert(message: errorMessage)
    }
}

// MARK: - UITableView
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TimelinePostCell
        
        let displayData = presenter.getPostDisplayData(with: indexPath.row)
        cell.lblUsername.text = displayData.username
        cell.txtContent.text = displayData.textContent
        
        return cell
    }
}
