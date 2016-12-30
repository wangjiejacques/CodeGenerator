//
//  SwiftParamMocker.swift
//  CodeGenerator
//
//  Created by WANG Jie on 28/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

struct SwiftParamMocker: ParamMocker {

    let param: FuncParam
    let funcName: String
    let indentation: String
    
    var variables: [VarSignature] {
        return [VarSignature.init(declaration: "var", name: "\(funcName)\(param.name.Capitalized)", type: param.type.optionalName)]
    }

    var lines: [String] {
        let line = "\(indentation.repeating(2))\(variables[0].name) = \(param.name)"
        return [line]
    }
}
