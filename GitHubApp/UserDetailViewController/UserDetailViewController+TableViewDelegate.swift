//
//  UserDetailViewController+TableViewDelegate.swift
//  GitHubApp
//
//  Created by 前川嵩博 on 2022/03/28.
//

import Foundation
import SafariServices


extension UserDetailViewController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GHRepositoryTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "GHRepositoryTableViewCell", for: indexPath) as! GHRepositoryTableViewCell
        let repoModel = self.repositoryList[indexPath.row]
        cell.repositoryNameLabel.text = repoModel.name
        if repoModel.language != nil {
            cell.languageLabel.text = "- \(repoModel.language!)"
        }else {
            cell.languageLabel.isHidden = true
        }
        if repoModel.description != nil {
            cell.descriptionLabel.text = repoModel.description
        }else {
            cell.descriptionLabel.isHidden = true
        }
        cell.stargazersCountLabel.text = repoModel.stargazers_count.shortenCount()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let repoModel = self.repositoryList[indexPath.row]
        guard let url = NSURL(string: repoModel.html_url) else {
            return
        }
        let safariVC = SFSafariViewController(url: url as URL)
        self.present(safariVC, animated: true)

    }

}
