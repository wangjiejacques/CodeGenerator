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

    func generator(with invocation: XCSourceEditorCommandInvocation, selections: [XCSourceTextRange]) throws -> Generator

    func generator(with invocation: XCSourceEditorCommandInvocation) throws -> Generator

    func swiftPerform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void)

    func generateForAllVariables(with invocation: XCSourceEditorCommandInvocation) throws

    func generateForSelectedVariables(with invocation: XCSourceEditorCommandInvocation, selections: [XCSourceTextRange]) throws
}

extension SelectableGeneratorCommand where Self: NSObject {
    func swiftPerform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        var selections = invocation.buffer.selections.map { $0 as! XCSourceTextRange }
        selections = selections.filter { $0.start != $0.end }
        do {
            if selections.isEmpty {
                try generateForAllVariables(with: invocation)
            } else {
                try generateForSelectedVariables(with: invocation, selections: selections)
            }
            completionHandler(nil)
        } catch {
            completionHandler(error)
        }
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

    func generator(with invocation: XCSourceEditorCommandInvocation, selections: [XCSourceTextRange]) throws -> Generator {
        let selectedVars = selectedLines(with: invocation, selections: selections).flatMap { VarSignature(string: $0) }
        return generatorType.init(interfaceDefinition: try interfaceSignature(of: invocation).definition, varSignatures: selectedVars, indentation: " ".repeating(invocation.buffer.indentationWidth))
    }

    func generator(with invocation: XCSourceEditorCommandInvocation) throws -> Generator {
        return generatorType.init(interfaceSignature: try interfaceSignature(of: invocation), indentation: " ".repeating(invocation.buffer.indentationWidth))
    }
}

extension XCSourceTextPosition: Equatable {
    public static func==(l: XCSourceTextPosition, r: XCSourceTextPosition) -> Bool {
        return l.column == r.column && r.line == l.line
    }
}

func interfaceSignature(of invocation: XCSourceEditorCommandInvocation) throws -> InterfaceSignature {
    return try InterfaceSignature(interfaceSource: invocation.buffer.completeBuffer, lines: invocation.buffer.lines.map { $0 as! String })
}
