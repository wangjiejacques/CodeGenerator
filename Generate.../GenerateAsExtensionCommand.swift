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
    func generateForAllVariables(with invocation: XCSourceEditorCommandInvocation) throws {
        invocation.buffer.lines.addObjects(from: try generator(with: invocation).lines)
    }

    func generateForSelectedVariables(with invocation: XCSourceEditorCommandInvocation, selections: [XCSourceTextRange]) throws {
        invocation.buffer.lines.addObjects(from: try generator(with: invocation, selections: selections).lines)
    }
}
