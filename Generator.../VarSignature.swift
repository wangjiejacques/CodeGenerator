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
    var initValue: String?

    init?(string: String) {
        guard let _ = "^(?!.*static).*\\s(let|var) \\S".firstMatch(in: string) else {
            return nil
        }
        guard let result = "(var|let)\\s*(\\S*)\\s*:\\s*(\\S[^\\{]*[^ \\{])".firstMatch(in: string) else {
            return nil
        }
        declaration = string.substring(with: result.rangeAt(1))
        name = string.substring(with: result.rangeAt(2))
        let typeString = string.substring(with: result.rangeAt(3))
        type = TypeParser.parse(string: typeString)
        accessLevel =  AccessLevel(string: string)
    }

    init(declaration: String, name: String, type: SwiftType, accessLevel: AccessLevel = .internal) {
        self.declaration = declaration
        self.name = name
        self.type = type
        self.accessLevel = accessLevel
    }

    init(declaration: String, name: String, type: String, accessLevel: AccessLevel = .internal) {
        self.declaration = declaration
        self.name = name
        self.type = TypeParser.parse(string: type)
        self.accessLevel = accessLevel
    }

    var isPrivate: Bool {
        return accessLevel.isPrivate
    }
}

extension VarSignature: Equatable {
    static func ==(l: VarSignature, r: VarSignature) -> Bool {
        return l.declaration == r.declaration && l.name == r.name && l.type == r.type && l.accessLevel == r.accessLevel
    }
}



extension VarSignature {
    var rawType: String {
        return string(with: type.name)
    }

    var unwrappedType: String {
        return string(with: type.unwrappedName)
    }

    var optionalType: String {
        return string(with: type.optionalName)
    }

    var forceUnwrappedType: String {
        return string(with: type.forceUnwrappedName)
    }

    private func string(with type: String) -> String {
        if let initValue = initValue {
            return "\(declaration) \(name) = \(initValue)"
        }
        return "\(declaration) \(name): \(type)"
    }
}
