//
//  InterfaceDefinition.swift
//  CodeGenerator
//
//  Created by WANG Jie on 25/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

struct InterfaceDefinition {
    let name: String
    /// can be class, protocol, extension...
    let type: String
    let lineIndex: Int

    init(lines: [String]) throws {
        for (index, line) in lines.enumerated() {
            guard let definition = "(protocol|class|extension|struct) ([A-Za-z]*)".firstMatch(in: line) else {
                continue
            }
            name = line.substring(with: definition.rangeAt(2))
            type =  line.substring(with: definition.rangeAt(1))
            lineIndex = index
            return
        }
        throw NSError.sourceInvalid
    }
}

extension InterfaceDefinition: Equatable {
    static func ==(l: InterfaceDefinition, r: InterfaceDefinition) -> Bool {
        return l.name == r.name && l.type == r.type && l.lineIndex == r.lineIndex
    }
}
