//
//  AccessLevel.swift
//  CodeGenerator
//
//  Created by WANG Jie on 27/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

enum AccessLevel: String {
    case `open`  = "open"
    case `public` = "public"
    case `internal` = "internal"
    case `fileprivate` = "fileprivate"
    case `private` = "private"

    init(string: String) {
        let allLevels: [AccessLevel] = [.open, .public, .internal, .fileprivate, .private]
        for level in allLevels {
            if let result = " (\(level)) ".firstMatch(in: string) {
                self.init(rawValue: string.substring(with: result.rangeAt(1)))!
                return
            }
        }
        self.init(rawValue: "internal")!
    }

    var isPrivate: Bool {
        return self == .private || self == .fileprivate
    }
}
