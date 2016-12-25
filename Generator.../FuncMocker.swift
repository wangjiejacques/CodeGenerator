//
//  FuncMocker.swift
//  CodeGenerator
//
//  Created by WANG Jie on 25/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

struct FuncMocker {
    var sensibleVariables: [VarSignature] = []
    var wasCalledVariable: VarSignature
    var returnVariable: VarSignature?
    let funcSignature: FuncSignature
    let funcBodyLines: [String]
    let indentation: String
    let lines: [String]

    init(funcSignature: FuncSignature, indentationWidth: Int) {
        indentation = Array(repeating: " ", count: indentationWidth).reduce("", +)
        self.funcSignature = funcSignature
        for param in funcSignature.params {
            let variable = VarSignature(declaration: "var", name: funcSignature.name + param.name.capitalized, type: param.type)
            guard !sensibleVariables.contains(variable) else { continue }
            sensibleVariables.append(variable)
        }
        wasCalledVariable = VarSignature(declaration: "var", name:  funcSignature.readableName + "WasCalled", type: "Bool?")
        if !funcSignature.isReturnVoid {
            returnVariable = VarSignature(declaration: "var", name: funcSignature.readableName + "ShouldReturn", type: funcSignature.returnType)
        }

        var bodyLines = FuncMocker.funcBodyWithSensible(vars: sensibleVariables, indentation: indentation)
        let wasCalledBodyLine = "\(indentation)\(indentation)\(wasCalledVariable.name) = true"
        bodyLines.append(wasCalledBodyLine)
        if let returnVariable = returnVariable {
            let returnLine = "\(indentation)\(indentation)return \(returnVariable.name)"
            bodyLines.append(returnLine)
        }
        self.funcBodyLines = bodyLines

        var lines: [String] = []
        lines.append("\(indentation)\(funcSignature.rawString) {")
        lines.append(contentsOf: funcBodyLines)
        lines.append("\(indentation)}")
        self.lines = lines
    }

    private static func funcBodyWithSensible(vars: [VarSignature], indentation: String) -> [String] {
        var funcBodyLines: [String] = []
        vars.forEach { sensibleVariable in
            let bodyLine = "\(indentation)\(indentation)self.\(sensibleVariable.name) = \(sensibleVariable.name)"
            funcBodyLines.append(bodyLine)
        }
        return funcBodyLines
    }
}

extension FuncMocker {

}
