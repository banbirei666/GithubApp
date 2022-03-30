//
//  MainViewController.swift
//  GitHubApp
//
//  Created by 前川嵩博 on 2022/03/23.
//

import UIKit
import Kingfisher
import Alamofire


class MainViewController: UIViewController {

    // Http state and Label
    @IBOutlet weak var stateLabel: UILabel!
    var currentState: HttpState = HttpState.initial

    // SeachBar and text
    @IBOutlet weak var searchBar: UISearchBar!
    var searchText: String = ""

    // user list's tableView
    @IBOutlet weak var tableView: UITableView!
    
    // fetchable user's count
    var total_count: Int!
    
    // fetched user's count
    var ghUserList: [GHUser] = []
    
    // Delay in http request
    var timer: Timer!
    
    // for page count
    var currentPage: Int = 1
    
    // Navigation bar button
    var favoriteListButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // User List observer
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotifySearchUserList(notification:)), name: .notifySearchUserList, object: nil)

        // User List observer
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotifySearchUserState(notification:)), name: .notifySearchUserState, object: nil)

        // Navigation bar title
        self.title = "Search"
        
        // Nabigation bar button
        self.favoriteListButton = UIBarButtonItem(image: UIImage(systemName: "list.star"), style: .plain, target: self, action: #selector(navigationFavoriteButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = self.favoriteListButton
        
        // tableView delegate etc.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "GHUserTableViewCell", bundle: nil), forCellReuseIdentifier: "GHUserTableViewCell")

        // searchBar delegate etc.
        self.searchBar.delegate = self
        self.searchBar.backgroundImage = UIImage()
        
    }
    
    
    // Observe tableView model
    @objc func receiveNotifySearchUserList(notification: Notification) {
        if notification.object == nil { return }
        guard let searchResult = notification.object as? GHSearchUser else {
            return
        }
        self.total_count = searchResult.total_count
        self.ghUserList += searchResult.items
        if self.ghUserList.isEmpty {
            NotificationCenter.default.post(name: .notifySearchUserState, object: HttpState.empty)
        }else {
            NotificationCenter.default.post(name: .notifySearchUserState, object: HttpState.finish)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // Observe http state
    @objc func receiveNotifySearchUserState(notification: Notification) {
        if notification.object == nil { return }
        guard let state = notification.object as? HttpState else {
            return
        }
        self.currentState = state
        var text = ""
        switch state {
        case HttpState.initial:
            text = "Search Github users"
            break
        case HttpState.loading:
            text = "Loading..."
            break
        case HttpState.finish :
            text = ""
            break
        case HttpState.failure:
            text = "Error."
            break
        case HttpState.empty:
            text = "Not found"
            break
        }

        
        DispatchQueue.main.async {
            self.stateLabel.text = text
        }
        
    }
    
    // Navigation bar favorite button
    @objc func navigationFavoriteButtonTapped(_ sender: UIBarButtonItem) {
        let vc: FavoriteListViewController = FavoriteListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    // http request
    func searchUser(text: String, page: Int) {
        
        NotificationCenter.default.post(name: .notifySearchUserState, object: HttpState.loading)

        var urlString: String = ""
        urlString = AppConstant.GH_BASE_URL
        urlString += "/search"
        urlString += "/users"
        urlString += "?q=\(text)+in:login"
        urlString += "&page=\(self.currentPage)"

        let headers: HTTPHeaders = ["Accept": "application/vnd.github.v3+json", "Authorization": "token \(SecretConstant.GH_AUTH_TOKEN)"]
        AF.request(urlString, method: .get, encoding: URLEncoding(destination: .queryString), headers: headers).response { response in
            guard let data = response.data else {
                NotificationCenter.default.post(name: .notifySearchUserState, object: HttpState.failure)

                return
            }
            do {
                let model = try JSONDecoder().decode(GHSearchUser.self, from: data)

                NotificationCenter.default.post(name: .notifySearchUserList, object: model)
                
            } catch let error {
                print(error)
                                    
                NotificationCenter.default.post(name: .notifySearchUserState, object: HttpState.failure)

            }
        }
        
    }
    
    

}
