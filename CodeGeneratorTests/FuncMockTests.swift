//
//  FuncMockerTests.swift
//  CodeGenerator
//
//  Created by WANG Jie on 25/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import XCTest
@testable import CodeGenerator

class FuncMockerTests: XCTestCase {

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
        let funcMocker = FuncMocker(funcSignature: funcSignature, indentationWidth: 1)
        XCTAssertEqual(funcMocker.sensibleVariables.count, 2)
        XCTAssertEqual(funcMocker.sensibleVariables[0], VarSignature(declaration: "var", name: "func2Closure", type: "(String?) -> Int?"))
        XCTAssertEqual(funcMocker.sensibleVariables[1], VarSignature(declaration: "var", name: "func2Closure2", type: "(String?) -> String?"))
        XCTAssertEqual(funcMocker.wasCalledVariable, VarSignature(declaration: "var", name: "func2ClosureWasCalled", type: "Bool?"))
        XCTAssertEqual(funcMocker.returnVariable, VarSignature(declaration: "var", name: "func2ClosureShouldReturn", type: "String?"))

        XCTAssertEqual(funcMocker.funcBodyLines.count, 4)
        XCTAssertEqual(funcMocker.funcBodyLines[0], "  func2Closure = closure")
        XCTAssertEqual(funcMocker.funcBodyLines[1], "  func2Closure2 = closure2")
        XCTAssertEqual(funcMocker.funcBodyLines[2], "  func2ClosureWasCalled = true")
        XCTAssertEqual(funcMocker.funcBodyLines[3], "  return func2ClosureShouldReturn")
    }

    func testFuncMocker1() {
        let funcSignature = FuncSignature(string: "func func3() {")
        let funcMocker = FuncMocker(funcSignature: funcSignature, indentationWidth: 1)
        XCTAssertEqual(funcMocker.sensibleVariables.count, 0)
        XCTAssertEqual(funcMocker.wasCalledVariable, VarSignature(declaration: "var", name: "func3WasCalled", type: "Bool?"))
        XCTAssertNil(funcMocker.returnVariable)
    }
}
