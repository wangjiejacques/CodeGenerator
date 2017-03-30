//
//  InitGenerator.swift
//  CodeGenerator
//
//  Created by WANG Jie on 30/03/2017.
//  Copyright © 2017 wangjie. All rights reserved.
//

import Foundation

struct InitGenerator: Generator {
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
        
        return lines
    }
}
