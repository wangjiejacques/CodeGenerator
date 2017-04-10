//
//  SelectableGeneratorCommand.swift
//  CodeGenerator
//
//  Created by WANG Jie on 02/01/2017.
//  Copyright © 2017 wangjie. All rights reserved.
//

import Foundation
import XcodeKit

protocol SelectableGeneratorCommand: XCSourceEditorCommand {

    var generatorType: Generator.Type { get }

    func generator(with invocation: XCSourceEditorCommandInvocation, selections: [XCSourceTextRange]) -> Generator

    func generator(with invocation: XCSourceEditorCommandInvocation) -> Generator

    func swiftPerform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void)

    func generateForAllVariables(with invocation: XCSourceEditorCommandInvocation)

    func generateForSelectedVariables(with invocation: XCSourceEditorCommandInvocation, selections: [XCSourceTextRange])
}

extension SelectableGeneratorCommand where Self: NSObject {
    func swiftPerform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        var selections = invocation.buffer.selections.map { $0 as! XCSourceTextRange }
        selections = selections.filter { $0.start != $0.end }
        if selections.isEmpty {
            generateForAllVariables(with: invocation)
        } else {
            generateForSelectedVariables(with: invocation, selections: selections)
        }
        completionHandler(nil)
    }

    private func selectedLines(with invocation: XCSourceEditorCommandInvocation, selections: [XCSourceTextRange]) -> [String] {
        let selectedColumns = selections.map { $0.start.line...$0.end.line }.flatMap { $0 }
        var selectedLines: [String] = []
        invocation.buffer.lines.enumerated().forEach { index, line in
            if selectedColumns.contains(index) {
                selectedLines.append(line as! String)
            }
        }
        return selectedLines
    }

    func generator(with invocation: XCSourceEditorCommandInvocation, selections: [XCSourceTextRange]) -> Generator {
        let selectedVars = selectedLines(with: invocation, selections: selections).flatMap { VarSignature(string: $0) }
        return generatorType.init(interfaceDefinition: interfaceSignature(of: invocation).definition, varSignatures: selectedVars, indentation: " ".repeating(invocation.buffer.indentationWidth))
    }

    func generator(with invocation: XCSourceEditorCommandInvocation) -> Generator {
        return generatorType.init(interfaceSignature: interfaceSignature(of: invocation), indentation: " ".repeating(invocation.buffer.indentationWidth))
    }
}

extension XCSourceTextPosition: Equatable {
    public static func==(l: XCSourceTextPosition, r: XCSourceTextPosition) -> Bool {
        return l.column == r.column && r.line == l.line
    }
}

func interfaceSignature(of invocation: XCSourceEditorCommandInvocation) -> InterfaceSignature {
    return InterfaceSignature(interfaceSource: invocation.buffer.completeBuffer, lines: invocation.buffer.lines.map { $0 as! String })
}
