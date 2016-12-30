//
//  GenerateMockCommand.swift
//  Generate...
//
//  Created by WANG Jie on 25/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation
import XcodeKit

class GenerateMockCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) {
        let interfaceSignature = InterfaceSignature(interfaceSource: invocation.buffer.completeBuffer, lines: invocation.buffer.lines.map { $0 as! String })
        let interfaceMocker = InterfaceMocker(interfaceSignature: interfaceSignature, indentationWidth: invocation.buffer.indentationWidth)
        invocation.buffer.lines.add("")
        invocation.buffer.lines.add("")
        invocation.buffer.lines.addObjects(from: interfaceMocker.lines)
        completionHandler(nil)
    }
}
