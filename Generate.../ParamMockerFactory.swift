//
//  ParamMockerFactory.swift
//  CodeGenerator
//
//  Created by WANG Jie on 29/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

struct ParamMockerFactory {

    private static let funcMockers: [String: (FuncParam, String, String) -> ParamMocker] = [
        String(describing: SwiftType.self): { SwiftParamMocker(param: $0, funcName: $1, indentation: $2) },
        String(describing: ClosureType.self): { ClosureParamMocker(param: $0, funcName: $1, indentation: $2) }]

    static func create(funcParam: FuncParam, funcName: String, indentation: String) -> ParamMocker {
        return funcMockers[String(describing: type(of: funcParam.type))]!(funcParam, funcName, indentation)
    }
}
