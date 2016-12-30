//
//  GenerateEquatableCommand.swift
//  CodeGenerator
//
//  Created by WANG Jie on 27/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation
import XcodeKit

class GenerateEquatableCommand: NSObject, XCSourceEditorCommand {

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) {
        var selections = invocation.buffer.selections.map { $0 as! XCSourceTextRange }
        selections = selections.filter { $0.start != $0.end }
        if selections.isEmpty {
            generateForAllVariables(with: invocation)
        } else {
            generateForSelectedVariables(with: invocation, selections: selections)
        }
        completionHandler(nil)
    }

    private func generateForAllVariables(with invocation: XCSourceEditorCommandInvocation) {
        let equatableGenerator = EquatableGenerator(interfaceSignature: interfaceSignature(of: invocation), indentation: " ".repeating(invocation.buffer.indentationWidth))
        invocation.buffer.lines.addObjects(from: equatableGenerator.lines)
    }

    private func generateForSelectedVariables(with invocation: XCSourceEditorCommandInvocation, selections: [XCSourceTextRange]) {
        let selectedColumns = selections.map { $0.start.line...$0.end.line }.flatMap { $0 }
        var selectedLines: [String] = []
        invocation.buffer.lines.enumerated().forEach { index, line in
            if selectedColumns.contains(index) {
                selectedLines.append(line as! String)
            }
        }
        let selectedVars = selectedLines.flatMap { VarSignature(string: $0) }
        let equatableGenerator = EquatableGenerator(interfaceDefinition: interfaceSignature(of: invocation).definition, varSignatures: selectedVars, indentation: " ".repeating(invocation.buffer.indentationWidth))
        invocation.buffer.lines.addObjects(from: equatableGenerator.lines)
    }
}

extension XCSourceTextPosition: Equatable {
    public static func==(l: XCSourceTextPosition, r: XCSourceTextPosition) -> Bool {
        return l.column == r.column && r.line == l.line
    }
}

private func interfaceSignature(of invocation: XCSourceEditorCommandInvocation) -> InterfaceSignature {
    return InterfaceSignature(interfaceSource: invocation.buffer.completeBuffer, lines: invocation.buffer.lines.map { $0 as! String })
}
