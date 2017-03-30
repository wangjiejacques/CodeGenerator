//
//  InitGenerator.swift
//  CodeGenerator
//
//  Created by WANG Jie on 30/03/2017.
//  Copyright © 2017 wangjie. All rights reserved.
//

import Foundation

struct InitGenerator: Generator {
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
        var initParams = [String]()
        for varSignature in varSignatures {
            var type = varSignature.type.name
            if varSignature.type.isOptional {
                type = varSignature.type.optionalName
            }
            initParams.append("\(varSignature.name): \(type)")
        }
        lines.append("\(indentation)init(\(initParams.joined(separator: ", "))) {")
        for varSignature in varSignatures {
            lines.append("\(indentation.repeating(2))self.\(varSignature.name) = \(varSignature.name)")
        }
        lines.append("\(indentation)}")
        return lines
    }
}
