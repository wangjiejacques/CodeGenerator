//
//  GenerateHashableCommand.swift
//  CodeGenerator
//
//  Created by WANG Jie on 02/01/2017.
//  Copyright © 2017 wangjie. All rights reserved.
//

import Foundation
import XcodeKit

class GenerateHashableCommand: NSObject, GenerateAsExtensionCommand {

    var generatorType: Generator.Type {
        return HashableGenerator.self
    }
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        swiftPerform(with: invocation, completionHandler: completionHandler)
    }
}
