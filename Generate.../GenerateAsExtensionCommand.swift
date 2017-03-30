//
//  GenerateAsExtensionCommand.swift
//  CodeGenerator
//
//  Created by WANG Jie on 30/03/2017.
//  Copyright © 2017 wangjie. All rights reserved.
//

import Foundation
import XcodeKit

protocol GenerateAsExtensionCommand: SelectableGeneratorCommand {

}

extension GenerateAsExtensionCommand {
    func generateForAllVariables(with invocation: XCSourceEditorCommandInvocation) {
        invocation.buffer.lines.addObjects(from: generator(with: invocation).lines)
    }

    func generateForSelectedVariables(with invocation: XCSourceEditorCommandInvocation, selections: [XCSourceTextRange]) {
        invocation.buffer.lines.addObjects(from: generator(with: invocation, selections: selections).lines)
    }
}
