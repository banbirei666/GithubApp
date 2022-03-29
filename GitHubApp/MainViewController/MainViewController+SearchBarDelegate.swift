//
//  MainViewController+SearchBarDelegate.swift
//  GitHubApp
//
//  Created by 前川嵩博 on 2022/03/26.
//

import UIKit
import Foundation


extension MainViewController: UISearchBarDelegate {
    
    // SearchBar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText
        
        if self.searchText == "" {
            return
        }


        // Delay http request
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            
            // Set to page 1, and fetch uesrs
            self.currentPage = 1
            self.ghUserList.removeAll()
            self.searchUser(text: self.searchText, page: self.currentPage)
            
        }
    }
    
}
