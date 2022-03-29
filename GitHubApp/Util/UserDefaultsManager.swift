//
//  UserDefaultsManager.swift
//  GitHubApp
//
//  Created by 前川嵩博 on 2022/03/29.
//

import Foundation

final public class UserDefaultsManager {
    public static let shared = UserDefaultsManager()
    private init() {}
    let UD_USERS_KEY: String = "favoriteUsers"
    
    // save or remove
    func toggleFavoriteUser(user: GHUser) -> Bool? {
        
        var loaded: [GHUser] = loadUsers()

        let isFavorite: Bool = loaded.contains(user)
        
        if isFavorite {
            loaded.remove(at: loaded.firstIndex(of: user)!)
        }else {
            loaded.append(user)
        }

        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(loaded) else {
            return nil
        }

        UserDefaults.standard.set(data, forKey: UD_USERS_KEY)
        
        return !isFavorite
    }
    
    func loadUsers() -> [GHUser] {
        let jsonDecoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: UD_USERS_KEY),
              let users = try? jsonDecoder.decode([GHUser].self, from: data) else {
            return []
        }
            
        return users
    }
    
    func isUserFavorite(user: GHUser) -> Bool{
        let loaded: [GHUser] = loadUsers()

        let isFavorite: Bool = loaded.contains(user)

        return isFavorite
    }
}
