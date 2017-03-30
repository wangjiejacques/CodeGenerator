//
//  GenerateEquatableCommand.swift
//  CodeGenerator
//
//  Created by WANG Jie on 27/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation
import XcodeKit

class GenerateEquatableCommand: NSObject, GenerateAsExtensionCommand {

    var generatorType: Generator.Type {
        return EquatableGenerator.self
    }
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        swiftPerform(with: invocation, completionHandler: completionHandler)
    }
}
