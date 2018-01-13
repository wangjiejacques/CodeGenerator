//
//  SwiftType.swift
//  CodeGenerator
//
//  Created by WANG Jie on 28/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

class SwiftType {

    static let Void = SwiftType(rawString: "Void")

    let rawString: String

    init(rawString: String) {
        self.rawString = rawString.trimed
    }

    var name: String {
        return rawString
    }

    var isSensible: Bool {
        return true
    }

    var unwrappedName: String {
        if isOptional {
            return String(name[..<name.index(before: name.endIndex)])
        }
        return name
    }

    func name(with wrap: String) -> String {
        return unwrappedName+wrap
    }

    var isOptional: Bool {
        guard !name.isEmpty else { return false }
        return  ("?!").contains(name.last!)
    }

    var optionalName: String {
        return name(with: "?")
    }

    var forceUnwrappedName: String {
        return name(with: "!")
    }

}


extension SwiftType: Equatable {
    static func ==(lhs: SwiftType, rhs: SwiftType) -> Bool {
        return lhs.rawString == rhs.rawString
    }
}
