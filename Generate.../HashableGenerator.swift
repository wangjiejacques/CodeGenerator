//
//  HashableGenerator.swift
//  CodeGenerator
//
//  Created by WANG Jie on 02/01/2017.
//  Copyright © 2017 wangjie. All rights reserved.
//

import Foundation

struct HashableGenerator: Generator {
    var equatableGenerator: EquatableGenerator

    var interfaceName: String {
        return equatableGenerator.interfaceDefinition.name
    }

    var indentation: String {
        return equatableGenerator.indentation
    }

    var varSignatures: [VarSignature] {
        return equatableGenerator.varSignatures
    }

    init(interfaceSignature: InterfaceSignature, indentation: String) {
        self.equatableGenerator = EquatableGenerator(interfaceSignature: interfaceSignature, indentation: indentation)
    }

    init(interfaceDefinition: InterfaceDefinition, varSignatures: [VarSignature], indentation: String) {
        self.equatableGenerator = EquatableGenerator(interfaceDefinition: interfaceDefinition, varSignatures: varSignatures, indentation: indentation)
    }

    var lines: [String] {
        var lines = [String]()
        lines.append("")
        lines.append("extension \(interfaceName): Hashable {")
        lines.append(contentsOf: equatableGenerator.equatableLines)
        lines.append("")
        lines.append(contentsOf: hashValueLines)
        lines.append("}")
        return lines
    }

    var hashValueLines: [String] {
        var lines = [String]()
        lines.append("\(indentation)var hashValue: Int {")
        lines.append("\(indentation)\(indentation)var hashValue = 1")
        let hashableVars = varSignatures.map { $0.name }.joined(separator: ", ")
        var varsType = "[AnyHashable]"
        var varHash = "$0.hashValue"
        if (varSignatures.filter { $0.type.isOptional }).count > 0 {
            varsType = "[AnyHashable?]"
            varHash = "($0?.hashValue ?? 0)"
        }
        lines.append("\(indentation)\(indentation)let hashableVars: \(varsType) = [\(hashableVars)]")

        lines.append("\(indentation)\(indentation)hashableVars.forEach {")
        lines.append("\(indentation)\(indentation)\(indentation)hashValue = 31 * hashValue + \(varHash)")
        lines.append("\(indentation)\(indentation)}")
        lines.append("\(indentation)\(indentation)return hashValue")
        lines.append("\(indentation)}")
        return lines
    }
}
