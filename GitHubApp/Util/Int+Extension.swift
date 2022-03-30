//
//  Int+Extension.swift
//  GitHubApp
//
//  Created by 前川嵩博 on 2022/03/30.
//

import Foundation


extension Int {

    func shortenCount() -> String {
        var ret = ""
        if self < 1000 {
            ret = String(self)
        } else if 1000 <= self && self < 1000000 {
            ret = "\((Double(self) * 10 / 1000).rounded() / 10)k"
        }else if 1000000 <= self && self < 1000000000 {
            ret = "\((Double(self) * 10 / 1000000).rounded() / 10)M"
        }
        print(ret)
        return ret
    }

}
