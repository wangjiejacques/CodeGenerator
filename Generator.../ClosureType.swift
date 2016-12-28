//
//  ClosureType.swift
//  CodeGenerator
//
//  Created by WANG Jie on 28/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

class ClosureType: SwiftType {

    override func name(with wrap: String) -> String {
        return "(\(unwrappedName))\(wrap)"
    }

    override var unwrappedName: String {
        if isOptional {
            let result = "^\\((.*\\))[?!]$".firstMatch(in: name)!
            return name.substring(with: result.rangeAt(1))
        }
        return name
    }

    override var isOptional: Bool {
        guard name.characters.count > 7 else { return false }
        let comps = name.components(separatedBy: "->")
        guard comps.count == 2 else { return false }
        let leftParenthesesCount = comps[1].count(of: "(")
        let rightParentesescount = comps[1].count(of: ")")
        let lastTwo = name.substring(from: name.index(name.endIndex, offsetBy: -2))
        return [")?", ")!"].contains(lastTwo) && leftParenthesesCount != rightParentesescount
    }
}
