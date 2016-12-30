//
//  InterfaceMockerTests.swift
//  CodeGenerator
//
//  Created by WANG Jie on 26/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import XCTest
@testable import CodeGenerator

class InterfaceMockerTests: XCTestCase {

    var interfaceMocker: InterfaceMocker!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInterface() {
        let interfaceSource = string(from: "interface1", ofType: "txt")
        let interface = InterfaceSignature(interfaceSource: interfaceSource, lines: interfaceSource.components(separatedBy: "\n"))
        let interfaceMocker = InterfaceMocker(interfaceSignature: interface, indentationWidth: 4)

        let mockSource = string(from: "interface1Mock", ofType: "txt")
        var mockSourceLines = mockSource.components(separatedBy: "\n")
        mockSourceLines.removeLast()
        XCTAssertEqual(interfaceMocker.mockSource.count, mockSourceLines.count)
        let size = min(interfaceMocker.mockSource.count, mockSourceLines.count)
        for i in 0..<size {
            XCTAssertEqual(interfaceMocker.mockSource[i], mockSourceLines[i], "line\(i) failure")
        }
    }

}
