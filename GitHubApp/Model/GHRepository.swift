//
//  GHRepository.swift
//  GitHubApp
//
//  Created by 前川嵩博 on 2022/03/26.
//

import Foundation


struct GHRepository: Codable {
    let id: Int
    let node_id: String
    let owner: GHUser
    let name: String
    let `private`: Bool
    let html_url: String
    let fork: Bool
    let language: String?
    let description: String?
    let stargazers_count: Int
}

