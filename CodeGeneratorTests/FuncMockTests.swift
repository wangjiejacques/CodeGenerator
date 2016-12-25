//
//  FuncMockTests.swift
//  CodeGenerator
//
//  Created by WANG Jie on 25/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import XCTest
@testable import CodeGenerator

class FuncMockTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

//    func func2(closure: (String?) -> Int?, closure2Label closure2: @escaping (String?) -> String?) -> String? {
//        self.func2Closure = func2Closure
//        self.func2Closure2 = func2Closure2
//        func2ClosureWasCalled = true
//        return func2ClosureShouldReturn
//    }

    func testFunMock() {
        let funcSignature = FuncSignature(string: "func func2(closure: (String?) -> Int?, closure2Label closure2: @escaping (String?) -> String?) -> String? {")
        let funcMock = FuncMock(funcSignature: funcSignature, indentationWidth: 1)
        XCTAssertEqual(funcMock.sensibleVariables.count, 2)
        XCTAssertEqual(funcMock.sensibleVariables[0], VarSignature(declaration: "var", name: "func2Closure", type: "(String?) -> Int?"))
        XCTAssertEqual(funcMock.sensibleVariables[1], VarSignature(declaration: "var", name: "func2Closure2", type: "(String?) -> String?"))
        XCTAssertEqual(funcMock.wasCalledVariable, VarSignature(declaration: "var", name: "func2ClosureWasCalled", type: "Bool?"))
        XCTAssertEqual(funcMock.returnVariable, VarSignature(declaration: "var", name: "func2ClosureShouldReturn", type: "String?"))

        XCTAssertEqual(funcMock.funcBodyLines.count, 4)
        XCTAssertEqual(funcMock.funcBodyLines[0], "  self.func2Closure = func2Closure")
        XCTAssertEqual(funcMock.funcBodyLines[1], "  self.func2Closure2 = func2Closure2")
        XCTAssertEqual(funcMock.funcBodyLines[2], "  func2ClosureWasCalled = true")
        XCTAssertEqual(funcMock.funcBodyLines[3], "  return func2ClosureShouldReturn")
    }

    func testFuncMock1() {
        let funcSignature = FuncSignature(string: "func func3() {")
        let funcMock = FuncMock(funcSignature: funcSignature, indentationWidth: 1)
        XCTAssertEqual(funcMock.sensibleVariables.count, 0)
        XCTAssertEqual(funcMock.wasCalledVariable, VarSignature(declaration: "var", name: "func3WasCalled", type: "Bool?"))
        XCTAssertNil(funcMock.returnVariable)
    }
}
