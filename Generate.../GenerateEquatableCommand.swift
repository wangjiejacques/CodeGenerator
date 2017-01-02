//
//  GenerateEquatableCommand.swift
//  CodeGenerator
//
//  Created by WANG Jie on 27/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation
import XcodeKit

class GenerateEquatableCommand: NSObject, SelectableGeneratorCommand {

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        swiftPerform(with: invocation, completionHandler: completionHandler)
    }


    func generator(with invocation: XCSourceEditorCommandInvocation, selections: [XCSourceTextRange]) -> Generator {
        let selectedVars = selectedLines(with: invocation, selections: selections).flatMap { VarSignature(string: $0) }
        return EquatableGenerator(interfaceDefinition: interfaceSignature(of: invocation).definition, varSignatures: selectedVars, indentation: " ".repeating(invocation.buffer.indentationWidth))
    }

    func generator(with invocation: XCSourceEditorCommandInvocation) -> Generator {
        return EquatableGenerator(interfaceSignature: interfaceSignature(of: invocation), indentation: " ".repeating(invocation.buffer.indentationWidth))
    }
}
