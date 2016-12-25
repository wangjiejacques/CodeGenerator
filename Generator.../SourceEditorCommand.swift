//
//  SourceEditorCommand.swift
//  Generator...
//
//  Created by WANG Jie on 25/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation
import XcodeKit
import AppKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        let classDeclaration = invocation.classDescription
        var classDeclarationLineIndex = 0
        var funcVariables: [String: [(String, String)]] = [:]
        for (index, line) in (invocation.buffer.lines.map { $0 as! String }).enumerated() {
//            if line.contains(classDeclaration.type) {
//                classDeclarationLineIndex = index
//            }
//            guard let _ = "func .*?\\(".firstMatch(in: line) else { continue }
//
//            let funcSignature = line.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "\n", with: "")
//            funcVariables[funcSignature] = createVariableNeeded(line: funcSignature)
        }
        let indentSpace = Array(repeating: " ", count: invocation.buffer.indentationWidth).reduce("", +)

        let removeLength = invocation.buffer.lines.count - classDeclarationLineIndex
        invocation.buffer.lines.removeObjects(in: NSRange(location: classDeclarationLineIndex, length: removeLength))
        invocation.buffer.lines.add("class \(className)Mock: \(className) {")
        funcVariables.values.flatMap { $0 }.forEach { variable in
            invocation.buffer.lines.add(indentSpace+variable.0)
        }
        for (f, v) in funcVariables {
            invocation.buffer.lines.add("")
            invocation.buffer.lines.add("\(f) {")
            v.forEach { variable in
                if variable.1.contains("WasCalled") {
                    invocation.buffer.lines.add(indentSpace+indentSpace+"self.\(variable.1) = true")
                } else {
                    invocation.buffer.lines.add(indentSpace+indentSpace+"self.\(variable.1) = \(variable.1)")
                }
            }
            invocation.buffer.lines.add(indentSpace+"}")
        }
        invocation.buffer.lines.add("}")
        completionHandler(nil)
    }

    func createVariableNeeded(line: String) -> [(String, String)] {
        let funcNameRegex = "func (.*?)\\("
        guard let funcNameResult = funcNameRegex.firstMatch(in: line) else { return [] }
        let funcName = (line as NSString).substring(with: funcNameResult.rangeAt(1))
        let funcParamsRegex = "([a-zA-Z]*?)[\\s]*?:[\\s]*?([a-zA-Z]{1,100})"
        let funcParamsResults = funcParamsRegex.matches(in: line)
        guard funcParamsResults.count > 0 else {
            let variableName = funcName+"WasCalled";
            return [("var "+variableName + ": Bool?", variableName)]
        }

        var variables: [(String, String)] = []
        funcParamsResults.forEach {
            let paramName = (line as NSString).substring(with: $0.rangeAt(1))
            let paramType = (line as NSString).substring(with: $0.rangeAt(2))
            variables.append(("var \(paramName): \(paramType)?", paramName))
        }
        return variables
    }




}
