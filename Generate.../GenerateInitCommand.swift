//
//  GenerateInitCommand.swift
//  CodeGenerator
//
//  Created by WANG Jie on 30/03/2017.
//  Copyright © 2017 wangjie. All rights reserved.
//

import Foundation
import XcodeKit

class GenerateInitCommand: NSObject, GenerateAfterVarCommand {

    var generatorType: Generator.Type {
        return InitGenerator.self
    }

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        swiftPerform(with: invocation, completionHandler: completionHandler)
    }
}
