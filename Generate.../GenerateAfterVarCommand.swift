//
//  GenerateAfterVarCommand.swift
//  CodeGenerator
//
//  Created by WANG Jie on 30/03/2017.
//  Copyright © 2017 wangjie. All rights reserved.
//

import Foundation
import XcodeKit

protocol GenerateAfterVarCommand: SelectableGeneratorCommand {

}

extension GenerateAfterVarCommand {
    func generateForAllVariables(with invocation: XCSourceEditorCommandInvocation) {
        addLinesAfterVariables(invocation: invocation, lines: generator(with: invocation).lines)
    }

    func generateForSelectedVariables(with invocation: XCSourceEditorCommandInvocation, selections: [XCSourceTextRange]) {
        addLinesAfterVariables(invocation: invocation, lines: generator(with: invocation, selections: selections).lines)
    }

    private func addLinesAfterVariables(invocation: XCSourceEditorCommandInvocation, lines: [String]) {
        var lastVarIndex = 0
        var varStarted = false
        for l in invocation.buffer.lines {
            let line = l as! String
            if line.isVar {
                varStarted = true
            }
            if varStarted && !line.isVar {
                break
            }
            lastVarIndex += 1
        }
        invocation.buffer.lines.insert(lines, at: IndexSet(integersIn: lastVarIndex ..< lastVarIndex+lines.count))
    }
}

private extension String {
    var isVar: Bool {
        return self.contains("var") || self.contains("let")
    }
}
