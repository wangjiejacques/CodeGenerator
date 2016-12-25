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
    let type: String

    init(string: String) {
        guard let result = "(var|let)\\s*(\\S*)\\s*:\\s*(\\S[^\\{]*[^ \\{])".firstMatch(in: string) else {
            preconditionFailure("incorrect var format \(string)")
        }
        declaration = string.substring(with: result.rangeAt(1))
        name = string.substring(with: result.rangeAt(2))
        type = string.substring(with: result.rangeAt(3))
    }

    init(declaration: String, name: String, type: String) {
        self.declaration = declaration
        self.name = name
        self.type = type
    }
}

extension VarSignature: Equatable {
    static func ==(l: VarSignature, r: VarSignature) -> Bool {
        return l.declaration == r.declaration && l.name == r.name && l.type == r.type
    }
}

extension VarSignature {
    var rawString: String {
        return "\(declaration) \(name): \(type)"
    }
}
