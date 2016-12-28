//
//  FuncMocker.swift
//  CodeGenerator
//
//  Created by WANG Jie on 25/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

struct FuncMocker {
    var paramMockers: [ParamMocker] = []
    var wasCalledVariable: VarSignature
    var returnVariable: VarSignature?
    let funcSignature: FuncSignature
    let indentation: String

    init(funcSignature: FuncSignature, indentationWidth: Int) {
        let indentation = Array(repeating: " ", count: indentationWidth).reduce("", +)
        self.funcSignature = funcSignature
        wasCalledVariable = VarSignature(declaration: "var", name:  funcSignature.readableName + "WasCalled", type: "Bool?")
        paramMockers = funcSignature.params.map { ParamMockerFactory.create(funcParam: $0, funcName: funcSignature.name, indentation: indentation) }
        if !funcSignature.isReturnVoid {
            returnVariable = VarSignature(declaration: "var", name: funcSignature.readableName + "ShouldReturn", type: funcSignature.returnType.forceUnwrappedName)
        }
        self.indentation = indentation
    }

    var bodyLines: [String] {
        var bodyLines = paramMockers.flatMap { $0.lines }
        let wasCalledBodyLine = "\(indentation)\(indentation)\(wasCalledVariable.name) = true"
        bodyLines.append(wasCalledBodyLine)
        if let returnVariable = returnVariable {
            let returnLine = "\(indentation)\(indentation)return \(returnVariable.name)"
            bodyLines.append(returnLine)
        }
        return bodyLines
    }

    var lines: [String] {
        var lines: [String] = []
        lines.append("\(indentation)\(funcSignature.rawString) {")
        lines.append(contentsOf: bodyLines)
        lines.append("\(indentation)}")
        return lines
    }


    var sensibleVariables: [VarSignature] {
        return paramMockers.flatMap { $0.variables }
    }


    private static func funcBodyWithSensible(vars: [VarSignature], params: [FuncParam], indentation: String) -> [String] {
        guard vars.count == params.count else {
            preconditionFailure("sensible variables should euqal to sensible params")
        }
        var funcBodyLines: [String] = []
        for index in 0..<vars.count {
            let sensibleVariablName = vars[index].name
            let sensibleParamName = params[index].name
            let bodyLine = "\(indentation)\(indentation)\(sensibleVariablName) = \(sensibleParamName)"
            funcBodyLines.append(bodyLine)
        }
        return funcBodyLines
    }
}
