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

    override var name: String {
        return rawString.replacingOccurrences(of: "@escaping", with: "").replacingOccurrences(of: "@autoclosure", with: "").trimed
    }

    override var unwrappedName: String {
        if isOptional {
            let result = "^\\((.*)\\)[?!]$".firstMatch(in: name)!
            return name.substring(with: result.range(at: 1))
        }
        return name
    }

    override var isSensible: Bool {
        return false
    }

    override var isOptional: Bool {
        guard name.count > 7 else { return false }
        let comps = name.components(separatedBy: "->")
        guard comps.count == 2 else { return false }
        let leftParenthesesCount = comps[1].count(of: "(")
        let rightParentesescount = comps[1].count(of: ")")
        let lastTwo = name.suffix(2)
        return [")?", ")!"].contains(lastTwo) && leftParenthesesCount != rightParentesescount
    }

    var inTypes: [SwiftType] {
        let rawInTypes = unwrappedName.components(separatedBy: "->")[0]
        guard let result = "\\((.*)\\)".firstMatch(in: rawInTypes) else { return [] }
        let inTypesString = rawInTypes.substring(with: result.range(at: 1))
        if inTypesString.isEmpty {
            return []
        }
        return inTypesString.components(separatedBy: ",").map { TypeParser.parse(string: $0) }
    }

    var outType: SwiftType {
        let rawOutType = unwrappedName.components(separatedBy: "->")[1]
        return TypeParser.parse(string: rawOutType)
    }
}
