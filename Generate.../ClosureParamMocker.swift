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
        if let varOut = varOut {
            variables.append(varOut)
        }
        return variables
    }

    private var varShouldCallClosure: VarSignature {
        var varSignature = VarSignature(declaration: "var", name: "\(funcName)ShouldCall\(param.name.Capitalized)", type: TypeParser.parse(string: "Bool?"))
        varSignature.initValue = "true"
        return varSignature
    }

    private var varsIn: [VarSignature] {
        var varsIn = [VarSignature]()
        closureType.inTypes.enumerated().forEach { index, inType in
            varsIn.append(VarSignature(declaration: "var", name: "\(funcName)\(param.name.Capitalized)Param\(index)", type: inType.forceUnwrappedName))
        }
        return varsIn
    }

    private var varOut: VarSignature? {
        if closureType.outType == .Void {
            return nil
        }
        return VarSignature(declaration: "var", name: "\(funcName)\(param.name.Capitalized)DidReturn", type: TypeParser.parse(string: closureType.outType.optionalName))
    }

    var lines: [String] {
        var lines = [String]()
        lines.append("\(indentation.repeating(2))if \(varShouldCallClosure.name) {")
        let callClosure = "\(param.name)("+varsIn.map { $0.name }.joined(separator: ", ")+")"
        if let varOut = varOut {
            lines.append("\(indentation.repeating(3))\(varOut.name) = \(callClosure)")
        } else {
            lines.append("\(indentation.repeating(3))\(callClosure)")
        }
        lines.append("\(indentation.repeating(2))}")
        return lines
    }
}
