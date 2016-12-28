//
//  FuncParam.swift
//  CodeGenerator
//
//  Created by WANG Jie on 25/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation
private let wrongParamFormat = "params format incorrect"

struct FuncParam {
    let label: String
    let name: String
    let type: SwiftType

    var readableLabel: String {
        if label == "_" {
            return ""
        }
        return label
    }

    init(string: String) {
        let comps = string.components(separatedBy: ":")
        guard comps.count == 2 else {
            preconditionFailure(wrongParamFormat)
        }
        type = TypeParser.parse(string: comps[1].trimed)

        let labelNameComps = comps[0].components(separatedBy: " ").map { $0.spaceRemoved }.filter { !$0.isEmpty }
        if labelNameComps.count == 1 {
            label = labelNameComps[0]
            name = labelNameComps[0]
            return
        }
        if labelNameComps.count == 2 {
            let label = labelNameComps[0]
            self.label = label
            name = labelNameComps[1]
            return
        }
        preconditionFailure(wrongParamFormat)
    }

    init(label: String, name: String, type: String) {
        self.label = label
        self.name = name
        self.type = TypeParser.parse(string: type)
    }
}

extension FuncParam: Equatable {
    static func ==(l: FuncParam, r: FuncParam) -> Bool {
        return l.label == r.label && l.name == r.name && l.type == r.type
    }
}

extension FuncParam {
    var rawString: String {
        let rawString = "\(name): \(type.name)"
        if name == label {
            return rawString
        }
        return "\(label) \(rawString)"
    }
}
