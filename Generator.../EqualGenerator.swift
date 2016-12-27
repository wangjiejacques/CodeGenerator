//
//  EqualGenerator.swift
//  CodeGenerator
//
//  Created by WANG Jie on 27/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

struct EqualGenerator {
    let varSignatures: [VarSignature]
    let indentation: String
    let interfaceDefinition: InterfaceDefinition

    var interfaceName: String {
        return interfaceDefinition.name
    }

    init(interfaceSignature: InterfaceSignature, indentation: String) {
        self.varSignatures = interfaceSignature.varSignatures
        self.interfaceDefinition = interfaceSignature.definition
        self.indentation = indentation
    }

    init(interfaceDefinition: InterfaceDefinition, varSignatures: [VarSignature], indentation: String) {
        self.varSignatures = varSignatures
        self.interfaceDefinition = interfaceDefinition
        self.indentation = indentation
    }

    var lines: [String] {
        var lines = [String]()
        lines.append("")
        lines.append("extension \(interfaceName): Equatable {")
        lines.append("\(indentation)static func ==(lhs: \(interfaceName), rhs: \(interfaceName)) -> Bool {")
        var varsEquals = [String]()
        varSignatures.forEach { varSignature in
            varsEquals.append("lhs.\(varSignature.name) == rhs.\(varSignature.name)")
        }
        lines.append("\(indentation)\(indentation)return \(varsEquals.joined(separator: " && "))")
        lines.append("\(indentation)}")
        lines.append("}")
        return lines
    }
}
