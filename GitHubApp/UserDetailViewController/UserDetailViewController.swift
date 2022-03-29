//
//  UserDetailViewController.swift
//  GitHubApp
//
//  Created by 前川嵩博 on 2022/03/24.
//

import UIKit
import Alamofire

class UserDetailViewController: UIViewController {
    
    // fetched user model
    var currentUser: GHUser!
    
    // Github unique id
    var login :String!
    
    // repository's tableView and list
    @IBOutlet weak var tableView: UITableView!
    var repositoryList: [GHRepository] = []
    
    // user's image, and name etc.
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!

    // repository state label
    @IBOutlet weak var noRepositoryLabel: UILabel!

    // Navigation bar button
    var favoriteButton: UIBarButtonItem!


    // constructor
    init(login: String) {
        self.login = login
        super.init(nibName: nil, bundle: nil)
    }
     
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if login != nil {
            // http request
            fetchUser(login: self.login)
            fetchRepository(login: self.login)
        }
        
        // Navigation bar title
        self.title = "Detail"
        
        // Nabigation bar button
        self.favoriteButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favoriteButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = self.favoriteButton
        
        // tableView delegate
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "GHRepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "GHRepositoryTableViewCell")
        self.tableView.estimatedRowHeight = 90         
        self.tableView.rowHeight = UITableView.automaticDimension
        
    }

    // Navigation bar favorite button
    @objc func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        let isFavorite: Bool? = UserDefaultsManager.shared.toggleFavoriteUser(user: self.currentUser)
        
        if isFavorite == nil {
            return
        }
        
        self.renderFavorite(isFavorite: isFavorite!)
    }

    func renderFavorite(isFavorite: Bool) {
        DispatchQueue.main.async {
            if isFavorite {
                self.favoriteButton.image = UIImage(systemName: "star.fill")
            }else {
                self.favoriteButton.image = UIImage(systemName: "star")
            }
        }
    }
    


    // http request, fetch specific user
    func fetchUser(login: String) {
        
        let urlString = "\(AppConstant.GH_BASE_URL)/users/\(login)"
        let headers: HTTPHeaders = ["Accept": "application/vnd.github.v3+json", "Authorization": "token \(SecretConstant.GH_AUTH_TOKEN)"]
        AF.request(urlString, method: .get, encoding: URLEncoding(destination: .queryString), headers: headers).response { response in
            guard let data = response.data else {
                return
            }
            do {
                let json = try JSONDecoder().decode(GHUser.self, from: data)
                self.currentUser = json
                let isFavorite: Bool? = UserDefaultsManager.shared.isUserFavorite(user: self.currentUser)
                
                self.userNameLabel.text = json.login
                self.fullNameLabel.text = json.node_id
                
                let url = URL(string: json.avatar_url)
                if url != nil {
                    self.userImageView.kf.setImage(with: url)
                }
                DispatchQueue.main.async {
                    if json.followers != nil {
                        self.followerLabel.text = "follower: \(json.followers!)"
                    }
                    if json.following != nil {
                        
                    }
                    self.followingLabel.text = "following: \(json.following!)"
                    
                    if isFavorite != nil {
                        self.renderFavorite(isFavorite: isFavorite!)
                    }
                    
                }
                
            } catch let error {
                print(error)
            }
        }
        
    }
    
    
    // http request, fetch specific user's repository
    func fetchRepository(login: String) {
        
        let urlString = "\(AppConstant.GH_BASE_URL)/users/\(login)/repos"
        let headers: HTTPHeaders = ["Accept": "application/vnd.github.v3+json", "Authorization": "token \(SecretConstant.GH_AUTH_TOKEN)"]
        AF.request(urlString, method: .get, encoding: URLEncoding(destination: .queryString), headers: headers).response { response in
            guard let data = response.data else {
                return
            }
            do {
                let json = try JSONDecoder().decode([GHRepository].self, from: data)
                
                // Exclude forking repositories
                self.repositoryList = json.filter { !$0.fork }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.noRepositoryLabel.isHidden = !self.repositoryList.isEmpty
                }
                
            } catch let error {
                print(error)
            }
        }
        
    }
}
