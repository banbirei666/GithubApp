//
//  FavoriteListViewController.swift
//  GitHubApp
//
//  Created by 前川嵩博 on 2022/03/29.
//

import UIKit

class FavoriteListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // Empty state label
    @IBOutlet weak var noFavoriteUserLabel: UILabel!
    
    // favorite users
    var favoriteUsers: [GHUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar
        self.title = "Favorite"
        
        // tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "GHUserTableViewCell", bundle: nil), forCellReuseIdentifier: "GHUserTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // load favorite users
        self.favoriteUsers = UserDefaultsManager.shared.loadUsers()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()

            // empty state
            if self.favoriteUsers.isEmpty {
                self.noFavoriteUserLabel.isHidden = false
            }else {
                self.noFavoriteUserLabel.isHidden = true
            }
        }
    }

}
