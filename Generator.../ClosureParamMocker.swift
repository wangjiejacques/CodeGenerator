//
//  ClosureParamMocker.swift
//  CodeGenerator
//
//  Created by WANG Jie on 28/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

struct ClosureParamMocker: ParamMocker {

    let param: FuncParam
    let funcName: String
    let indentation: String

    var closureType: ClosureType {
        return param.type as! ClosureType
    }
    
    var variables: [VarSignature] {
        var variables = [VarSignature]()
        variables.append(varShouldCallClosure)
        variables.append(contentsOf: varsIn)
        variables.append(varOut)
        return variables
    }

    private var varShouldCallClosure: VarSignature {
        return VarSignature(declaration: "var", name: "\(funcName)ShouldCall\(param.name.Capitalized)", type: TypeParser.parse(string: "Bool?"))
    }

    private var varsIn: [VarSignature] {
        var varsIn = [VarSignature]()
        closureType.inTypes.enumerated().forEach { index, inType in
            varsIn.append(VarSignature(declaration: "var", name: "\(funcName)\(param.name.Capitalized)Param\(index)", type: TypeParser.parse(string: inType.forceUnwrappedName)))
        }
        return varsIn
    }

    private var varOut: VarSignature {
        return VarSignature(declaration: "var", name: "\(funcName)\(param.name.Capitalized)DidReturn", type: TypeParser.parse(string: closureType.outType.optionalName))
    }

    var lines: [String] {
        var lines = [String]()
        lines.append("\(indentation.repeating(2))if \(varShouldCallClosure.name) {")
        lines.append("\(indentation.repeating(3))\(varOut.name) = \(param.name)("+varsIn.map { $0.name }.joined(separator: ", ")+")")
        lines.append("\(indentation.repeating(2))}")
        return lines
    }
}
