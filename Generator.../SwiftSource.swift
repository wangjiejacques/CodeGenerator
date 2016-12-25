//
//  SwiftSource.swift
//  CodeGenerator
//
//  Created by WANG Jie on 25/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

struct SwiftSource {
    let source: String
    let lines: [String]

    var definition: SourceDefinition?
    var funcSignatures: [FuncSignature] = []
    var varSignatures: [VarSignature] = []

    init(source: String, lines: [String]) {
        self.source = source
        self.lines = lines
        definition = SourceDefinition(lines: lines)
        initFuncSignatures()
        initVarSignatures()
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

    mutating func initVarSignatures() {
        var openBraceCount = 0
        var varSignatures: [String] = []
        for line in lines {
            openBraceCount += line.characters.filter { $0 == "{" }.count
            openBraceCount -= line.characters.filter { $0 == "}" }.count
            guard openBraceCount == 1 else { continue }
            guard let _ = "^(?!.*private)(?!.*static).*\\s(let|var) \\S".firstMatch(in: line) else { continue }
            varSignatures.append(line)
        }
        self.varSignatures = varSignatures.map { VarSignature(string: $0) }
    }
}
