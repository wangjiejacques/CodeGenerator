//
//  SwiftType.swift
//  CodeGenerator
//
//  Created by WANG Jie on 26/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

struct SwiftType {

    /// can be String, Int, Int?, Bool...
    let name: String
    /// can be String, Int, Bool...
    let unwrappedName: String

    init(string rawString: String) {
        let string = rawString.trimed
        name = string
        if string.isClosure {
            if string.isClosureOptional {
                let result = "^\\((.*\\))[?!]$".firstMatch(in: string)!
                unwrappedName = string.substring(with: result.rangeAt(1))
            } else {
                unwrappedName = string
            }
            return
        }
        if string.isOptional {
            unwrappedName = string.substring(to: string.index(before: string.endIndex))
            return
        }
        unwrappedName = string
    }

    var isOptional: Bool {
        if name.isClosure {
            return name.isClosureOptional
        }
        return name.isOptional
    }

    var isClosure: Bool {
        return name.contains("->")
    }
}

extension SwiftType: Equatable {
    static func ==(l: SwiftType, r: SwiftType) -> Bool {
        return l.name == r.name
    }
}

private extension String {
    var isOptional: Bool {
        guard !isEmpty else { return false }
        return  ("?!").characters.contains(characters.last!)
    }

    var isClosure: Bool {
        return contains("->")
    }

    var isClosureOptional: Bool {
        guard characters.count > 7 else { return false }
        let comps = components(separatedBy: "->")
        guard comps.count == 2 else { return false }
        let leftParenthesesCount = comps[1].count(of: "(")
        let rightParentesescount = comps[1].count(of: ")")
        let lastTwo = substring(from: index(endIndex, offsetBy: -2))
        return [")?", ")!"].contains(lastTwo) && leftParenthesesCount != rightParentesescount
    }
}
