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
    let funcSignature: FuncSignature
    let indentation: String

    init(funcSignature: FuncSignature, indentationWidth: Int) {
        let indentation = " ".repeating(indentationWidth)
        self.funcSignature = funcSignature
        paramMockers = funcSignature.params.map { ParamMockerFactory.create(funcParam: $0, funcName: funcSignature.name, indentation: indentation) }
        self.indentation = indentation
    }

    var sensibleVariables: [VarSignature] {
        return paramMockers.flatMap { $0.variables }
    }

    var wasCalledVariable: VarSignature {
        return VarSignature(declaration: "var", name:  funcSignature.readableName + "WasCalled", type: "Bool?")
    }

    var wasCalledTimesVariable: VarSignature {
        var varSignature = VarSignature(declaration: "var", name: funcSignature.readableName + "WasCalledTimes", type: "Int")
        varSignature.initValue = "0"
        return varSignature
    }

    var returnVariable: VarSignature? {
        if funcSignature.isReturnVoid {
            return nil
        }
        return VarSignature(declaration: "var", name: funcSignature.readableName + "ShouldReturn", type: funcSignature.returnType.forceUnwrappedName)
    }

    var bodyLines: [String] {
        var bodyLines = paramMockers.flatMap { $0.lines }
        let wasCalledBodyLine = "\(indentation)\(indentation)\(wasCalledVariable.name) = true"
        bodyLines.append(wasCalledBodyLine)
        let wasCalledTimesBodyLine = "\(indentation)\(indentation)\(wasCalledTimesVariable.name) += 1"
        bodyLines.append(wasCalledTimesBodyLine)
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
}
