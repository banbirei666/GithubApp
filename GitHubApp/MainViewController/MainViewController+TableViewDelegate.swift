//
//  MainViewController+TableViewDelegate.swift
//  GitHubApp
//
//  Created by 前川嵩博 on 2022/03/26.
//

import UIKit
import Foundation

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    // tableView delegate, dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ghUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GHUserTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "GHUserTableViewCell", for: indexPath) as! GHUserTableViewCell
        let user = self.ghUserList[indexPath.row]
        cell.userNameLabel.text = user.login
        
        let url = URL(string: user.avatar_url)
        if url != nil {
            cell.userImageView.kf.setImage(with: url)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: UserDetailViewController = UserDetailViewController(login: self.ghUserList[indexPath.row].login)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        /// more load
        if self.ghUserList.count < self.total_count && self.ghUserList.count - 10 < indexPath.row && self.currentState == HttpState.finish {
            
            self.currentPage += 1
            self.searchUser(text: self.searchText, page: self.currentPage)
        }
    }
    
}
