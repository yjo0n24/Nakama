//
//  TimelineVC.swift
//  Nakama
//
//  Created by Yew Joon Wong on 27/08/2022.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblTimeline: UITableView!
    
    // MARK: - Variables
    private let cellIdentifier = String(describing: TimelinePostCell.self)
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    private func registerCells() {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tblTimeline.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
}

// MARK: - UITableView
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TimelinePostCell
        return cell
    }
}
