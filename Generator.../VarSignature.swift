//
//  VarSignature.swift
//  CodeGenerator
//
//  Created by WANG Jie on 25/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

struct VarSignature {

    /// `let` or `var`
    let declaration: String
    let name: String
    let type: SwiftType
    var accessLevel: AccessLevel = .internal

    init(string: String) {
        guard let result = "(var|let)\\s*(\\S*)\\s*:\\s*(\\S[^\\{]*[^ \\{])".firstMatch(in: string) else {
            preconditionFailure("incorrect var format \(string)")
        }
        declaration = string.substring(with: result.rangeAt(1))
        name = string.substring(with: result.rangeAt(2))
        let typeString = string.substring(with: result.rangeAt(3))
        type = SwiftType(string: typeString)
        accessLevel =  AccessLevel(string: string)
    }

    init(declaration: String, name: String, type: String, accessLevel: AccessLevel = .internal) {
        self.declaration = declaration
        self.name = name
        self.type = SwiftType(string: type)
        self.accessLevel = accessLevel
    }
}

extension VarSignature: Equatable {
    static func ==(l: VarSignature, r: VarSignature) -> Bool {
        return l.declaration == r.declaration && l.name == r.name && l.type == r.type && l.accessLevel == r.accessLevel
    }
}

extension VarSignature {
    var rawString: String {
        return string(with: type.name)
    }

    var unwrappedString: String {
        return string(with: type.unwrappedName)
    }

    var optionalString: String {
        return string(with: type.optionalName)
    }

    var forceUnwrappedString: String {
        return string(with: type.forceUnwrappedName)
    }

    private func string(with type: String) -> String {
        return "\(declaration) \(name): \(type)"
    }
}
