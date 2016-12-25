//
//  SourceDefinition.swift
//  CodeGenerator
//
//  Created by WANG Jie on 25/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

struct SourceDefinition {
    let name: String
    /// can be class, struct, protocol, extension...
    let type: String
    let lineIndex: Int

    init(lines: [String]) {
        for (index, line) in lines.enumerated() {
            guard let definition = "(protocol|class|extension|struct) ([A-Za-z]*)".firstMatch(in: line) else {
                continue
            }
            name = (line as NSString).substring(with: definition.rangeAt(2))
            type =  (line as NSString).substring(with: definition.rangeAt(1))
            lineIndex = index
            return
        }
        preconditionFailure("source format incorrect")
    }
}

extension SourceDefinition: Equatable {
    static func ==(l: SourceDefinition, r: SourceDefinition) -> Bool {
        return l.name == r.name && l.type == r.type && l.lineIndex == r.lineIndex
    }
}
