//
//  GHSearchUser.swift
//  GitHubApp
//
//  Created by 前川嵩博 on 2022/03/28.
//

import Foundation

struct GHSearchUser: Codable {
    let total_count: Int
    let items: [GHUser]
}
