//
//  HttpState.swift
//  GitHubApp
//
//  Created by 前川嵩博 on 2022/03/26.
//

import Foundation


enum HttpState {
    case initial
    case loading
    case finish
    case empty
    case failure
}
