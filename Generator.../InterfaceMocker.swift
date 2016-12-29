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
    private (set) var mockSource: [String] = []

    private var interfaceName: String {
        return interfaceSignature.definition.name
    }

    init(interfaceSignature: InterfaceSignature, indentationWidth: Int) {
        indentation = Array(repeating: " ", count: indentationWidth).reduce("", +)
        self.interfaceSignature = interfaceSignature
        variables = interfaceSignature.varSignatures.filter { !$0.isPrivate }
        funcsMockers = interfaceSignature.funcSignatures.map { FuncMocker(funcSignature: $0, indentationWidth: indentationWidth) }
        sensibleVariables = funcsMockers.flatMap { $0.sensibleVariables }
        wasCalledVariables = funcsMockers.map { $0.wasCalledVariable }
        returnVariables = funcsMockers.flatMap { $0.returnVariable }

        initSource()
    }

    private mutating func initSource() {
        mockSource.append("class \(interfaceName)Mock: \(interfaceName) {")
        append(variables: variables, varType: { $0.rawType })
        append(variables: sensibleVariables, varType: { $0.rawType })
        append(variables: wasCalledVariables, varType: { $0.optionalType })
        append(variables: returnVariables, varType: { $0.forceUnwrappedType })
        funcsMockers.forEach { funcMocker in
            mockSource.append(contentsOf: funcMocker.lines)
            mockSource.append("")
        }
        mockSource.append("}")
    }

    private mutating func append(variables: [VarSignature], varType: (VarSignature) -> String) {
        guard !variables.isEmpty else { return }
        variables.forEach { mockSource.append("\(indentation)\(varType($0))") }
        mockSource.append("")
    }
}
