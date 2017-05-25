//
//  GenerateCodingCommand.swift
//  CodeGenerator
//
//  Created by WANG Jie on 25/05/2017.
//  Copyright © 2017 wangjie. All rights reserved.
//

import Foundation
import XcodeKit

class GenerateCodingCommand: NSObject, GenerateAfterVarCommand {

    var generatorType: Generator.Type {
        return CodingGenerator.self
    }

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        swiftPerform(with: invocation, completionHandler: completionHandler)
    }
}
