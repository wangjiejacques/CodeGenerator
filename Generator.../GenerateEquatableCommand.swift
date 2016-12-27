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

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        let interfaceSignature = InterfaceSignature(interfaceSource: invocation.buffer.completeBuffer, lines: invocation.buffer.lines.map { $0 as! String })
        let equatableGenerator = EquatableGenerator(interfaceSignature: interfaceSignature, indentation: Array(repeating: " ", count: invocation.buffer.indentationWidth).joined())
        invocation.buffer.lines.addObjects(from: equatableGenerator.lines)
        completionHandler(nil)
    }
}
