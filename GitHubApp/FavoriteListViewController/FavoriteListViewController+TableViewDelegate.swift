//
//  FavoriteListViewController+TableViewDelegate.swift
//  GitHubApp
//
//  Created by 前川嵩博 on 2022/03/29.
//

import Foundation
import UIKit

extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.favoriteUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GHUserTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "GHUserTableViewCell", for: indexPath) as! GHUserTableViewCell
        let user = self.favoriteUsers[indexPath.row]
        cell.userNameLabel.text = user.login
        
        let url = URL(string: user.avatar_url)
        if url != nil {
            cell.userImageView.kf.setImage(with: url)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: UserDetailViewController = UserDetailViewController(login: self.favoriteUsers[indexPath.row].login)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
