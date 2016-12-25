//
//  SwiftSource.swift
//  CodeGenerator
//
//  Created by WANG Jie on 25/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

public struct SwiftSource {
    let source: String
    let lines: [String]

    var definition: SourceDefinition?
    var funcSignatures: [FuncSignature] = []

    init(source: String, lines: [String]) {
        self.source = source
        self.lines = lines
        definition = SourceDefinition(lines: lines)
        initFuncSignatures()
    }

    mutating func initFuncSignatures() {
        var funcSignatures: [String] = []
        for line in lines {
            guard let _ = "func .*?\\(".firstMatch(in: line) else { continue }
            let funcSignature = line.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "\n", with: "")
            funcSignatures.append(funcSignature)
        }
        self.funcSignatures = funcSignatures.map { FuncSignature(string: $0) }
    }
}
