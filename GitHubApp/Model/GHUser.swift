//
//  GHUser.swift
//  GitHubApp
//
//  Created by 前川嵩博 on 2022/03/26.
//

import Foundation


struct GHUser: Codable, Equatable {
    let id: Int
    let node_id: String
    let login: String
    let avatar_url: String
    let html_url: String
    let followers: Int?
    let following: Int?
}
