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

    func generator(with invocation: XCSourceEditorCommandInvocation, selections: [XCSourceTextRange]) -> Generator

    func generator(with invocation: XCSourceEditorCommandInvocation) -> Generator

    func swiftPerform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void)
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

    fileprivate func generateForAllVariables(with invocation: XCSourceEditorCommandInvocation) {
        invocation.buffer.lines.addObjects(from: generator(with: invocation).lines)
    }

    fileprivate func generateForSelectedVariables(with invocation: XCSourceEditorCommandInvocation, selections: [XCSourceTextRange]) {
        invocation.buffer.lines.addObjects(from: generator(with: invocation, selections: selections).lines)
    }

    func selectedLines(with invocation: XCSourceEditorCommandInvocation, selections: [XCSourceTextRange]) -> [String] {
        let selectedColumns = selections.map { $0.start.line...$0.end.line }.flatMap { $0 }
        var selectedLines: [String] = []
        invocation.buffer.lines.enumerated().forEach { index, line in
            if selectedColumns.contains(index) {
                selectedLines.append(line as! String)
            }
        }
        return selectedLines
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
