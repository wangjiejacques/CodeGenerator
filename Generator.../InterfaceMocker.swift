//
//  InterfaceMocker.swift
//  CodeGenerator
//
//  Created by WANG Jie on 25/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

struct InterfaceMocker {
    let interfaceSignature: InterfaceSignature
    let variables: [VarSignature]
    let sensibleVariables: [VarSignature]
    let wasCalledVariables: [VarSignature]
    let returnVariables: [VarSignature]
    let funcsMockers: [FuncMocker]
    let indentation: String

    private var interfaceName: String {
        return interfaceSignature.definition.name
    }

    init(interfaceSignature: InterfaceSignature, indentationWidth: Int) {
        indentation = " ".repeating(indentationWidth)
        self.interfaceSignature = interfaceSignature
        variables = interfaceSignature.varSignatures.filter { !$0.isPrivate }
        funcsMockers = interfaceSignature.funcSignatures.map { FuncMocker(funcSignature: $0, indentationWidth: indentationWidth) }
        sensibleVariables = funcsMockers.flatMap { $0.sensibleVariables }
        wasCalledVariables = funcsMockers.map { $0.wasCalledVariable }
        returnVariables = funcsMockers.flatMap { $0.returnVariable }
    }

    var lines: [String] {
        var lines = [String]()
        lines.append("class \(interfaceName)Mock: \(interfaceName) {")
        lines += linesOf(variables: variables, varType: { $0.rawType })
        lines += linesOf(variables: sensibleVariables, varType: { $0.rawType })
        lines += linesOf(variables: wasCalledVariables, varType: { $0.optionalType })
        lines += linesOf(variables: returnVariables, varType: { $0.forceUnwrappedType })
        funcsMockers.forEach { funcMocker in
            lines.append(contentsOf: funcMocker.lines)
            lines.append("")
        }
        lines.append("}")
        return lines
    }

    private func linesOf(variables: [VarSignature], varType: (VarSignature) -> String) -> [String] {
        guard !variables.isEmpty else { return [] }
        var lines = [String]()
        variables.forEach { lines.append("\(indentation)\(varType($0))") }
        lines.append("")
        return lines
    }
}
