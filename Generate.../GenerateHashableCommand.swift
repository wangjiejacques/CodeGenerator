//
//  GenerateHashableCommand.swift
//  CodeGenerator
//
//  Created by WANG Jie on 02/01/2017.
//  Copyright © 2017 wangjie. All rights reserved.
//

import Foundation
import XcodeKit

class GenerateHashableCommand: NSObject, SelectableGeneratorCommand {

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        swiftPerform(with: invocation, completionHandler: completionHandler)
    }


    func generator(with invocation: XCSourceEditorCommandInvocation, selections: [XCSourceTextRange]) -> Generator {
        let selectedVars = selectedLines(with: invocation, selections: selections).flatMap { VarSignature(string: $0) }
        return HashableGenerator(interfaceDefinition: interfaceSignature(of: invocation).definition, varSignatures: selectedVars, indentation: " ".repeating(invocation.buffer.indentationWidth))
    }

    func generator(with invocation: XCSourceEditorCommandInvocation) -> Generator {
        return HashableGenerator(interfaceSignature: interfaceSignature(of: invocation), indentation: " ".repeating(invocation.buffer.indentationWidth))
    }
}
