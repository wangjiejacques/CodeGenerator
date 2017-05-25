//
//  CodingGenerator.swift
//  CodeGenerator
//
//  Created by WANG Jie on 23/05/2017.
//  Copyright © 2017 wangjie. All rights reserved.
//

import Foundation

struct CodingGenerator: Generator {
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
        lines.append(contentsOf: decodeLines)
        lines.append(contentsOf: encodeLines)
        return lines
    }

    var encodeLines: [String] {
        var lines = [String]()
        lines.append("")
        lines.append("\(indentation)func encode(with aCoder: NSCoder) {")
        for varSignature in varSignatures {
            lines.append("\(indentation.repeating(2))aCoder.encode(\(varSignature.name), forKey: \"\(varSignature.name)\")")
        }
        lines.append("\(indentation)}")
        return lines
    }

    var decodeLines: [String] {

        var lines = [String]()
        lines.append("")
        lines.append("\(indentation)required init?(coder aDecoder: NSCoder) {")
        var guards = "guard "
        varSignatures.filter { $0.shouldGuard }.forEach { varSignature in
            let guardVar = "let \(varSignature.name) = aDecoder.\(varSignature.decodeName), "
            guards.append(guardVar)
        }
        guards.removeSubrange(Range(uncheckedBounds: (lower: guards.index(guards.endIndex, offsetBy: -2), upper: guards.endIndex)))
        guards.append(" else { return nil }")
        lines.append(indentation.repeating(2) + guards)
        for varSignature in varSignatures {
            if varSignature.shouldGuard {
                lines.append(indentation.repeating(2) + "self.\(varSignature.name) = \(varSignature.name)")
                continue
            }
            if varSignature.type.isOptional {
                lines.append(indentation.repeating(2) + "if aDecoder.containsValue(forKey: \"\(varSignature.name)\") {")
                lines.append(indentation.repeating(3) + "\(varSignature.name) = aDecoder.\(varSignature.decodeName)")
                lines.append(indentation.repeating(2) + "}")
                continue
            }
            lines.append(indentation.repeating(2) + "\(varSignature.name) = aDecoder.\(varSignature.decodeName)")

        }
        lines.append("\(indentation)}")
        return lines
    }

}

private extension VarSignature {
    var shouldGuard: Bool {
        return isObject && !type.isOptional
    }

    var isObject: Bool {
        return decodeName.contains("decodeObject")
    }

    var decodeName: String {
        let types = ["Bool": "decodeBool", "Int32": "decodeInt32", "Int64": "decodeInt64", "Float": "decodeFloat", "Double": "decodeDouble", "Int": "decodeInteger"]
        guard let _ = types.index(forKey: type.unwrappedName) else {
            return "decodeObject(forKey: \"\(name)\") as? \(type.unwrappedName)"
        }
        return "\(types[type.unwrappedName]!)(forKey: \"\(name)\")"
    }
}
