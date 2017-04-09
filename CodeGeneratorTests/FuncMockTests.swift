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

    func testFunMock() {
        let funcSignature = FuncSignature(string: "func test(funcMock: String, successHandler: @escaping (String, Int?) -> String?) -> String {")
        let funcMocker = FuncMocker(funcSignature: funcSignature, indentationWidth: 1)
        XCTAssertEqual(funcMocker.sensibleVariables.count, 5)
        XCTAssertEqual(funcMocker.sensibleVariables[0], VarSignature(string: " var testFuncMock: String?"))

        XCTAssertEqual(funcMocker.sensibleVariables[1], VarSignature(string: " var testShouldCallSuccessHandler: Bool?"))
        XCTAssertEqual(funcMocker.sensibleVariables[2], VarSignature(string: " var testSuccessHandlerParam0: String!"))
        XCTAssertEqual(funcMocker.sensibleVariables[3], VarSignature(string: " var testSuccessHandlerParam1: Int!"))
        XCTAssertEqual(funcMocker.sensibleVariables[4], VarSignature(string: " var testSuccessHandlerDidReturn: String?"))
        XCTAssertEqual(funcMocker.wasCalledVariable, VarSignature(string: " var testFuncMockWasCalled: Bool?"))
        var wasCalledTimesVar = VarSignature(declaration: "var", name: "testFuncMockWasCalledTimes", type: "Int", accessLevel: .internal)
        wasCalledTimesVar.initValue = "0"
        XCTAssertEqual(funcMocker.wasCalledTimesVariable, wasCalledTimesVar)
        XCTAssertEqual(funcMocker.returnVariable, VarSignature(string: " var testFuncMockShouldReturn: String!"))

        var expectedBodyLines = string(from: "funcMock", ofType: "txt").components(separatedBy: "\n")
        expectedBodyLines.removeLast()
        XCTAssertEqual(funcMocker.bodyLines.count, expectedBodyLines.count)
        for i in 0..<expectedBodyLines.count {
            XCTAssertEqual(funcMocker.bodyLines[i], expectedBodyLines[i])
        }
    }

    func testFunReturnVoid() {
        let funcSignature = FuncSignature(string: "func test(funcMock: String, successHandler: @escaping (String, Int?) -> String?)")
        let funcMocker = FuncMocker(funcSignature: funcSignature, indentationWidth: 1)
        XCTAssertNil(funcMocker.returnVariable)
    }

    func testFuncMocker1() {
        let funcSignature = FuncSignature(string: "func func3() {")
        let funcMocker = FuncMocker(funcSignature: funcSignature, indentationWidth: 1)
        XCTAssertEqual(funcMocker.sensibleVariables.count, 0)
        XCTAssertEqual(funcMocker.wasCalledVariable, VarSignature(declaration: "var", name: "func3WasCalled", type: "Bool?"))
        XCTAssertNil(funcMocker.returnVariable)
    }
}
