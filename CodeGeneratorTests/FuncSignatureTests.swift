//
//  FuncSignatureTests.swift
//  CodeGenerator
//
//  Created by WANG Jie on 25/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import XCTest
@testable import CodeGenerator

class FuncSignatureTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFunc1() {
        let func1 = FuncSignature(string: "func func1(param1: String, param2Label param2: Bool, closureLabel closure: (String) -> Bool) -> Bool {")
        XCTAssertEqual(func1.name, "func1")
        XCTAssertEqual(func1.returnType, TypeParser.parse(string: "Bool"))
        XCTAssertEqual(func1.params.count, 3)
        XCTAssertEqual(func1.params[0], FuncParam(label: "param1", name: "param1", type: "String"))
        XCTAssertEqual(func1.params[1], FuncParam(label: "param2Label", name: "param2", type: "Bool"))
        XCTAssertEqual(func1.params[2], FuncParam(label: "closureLabel", name: "closure", type: "(String) -> Bool"))
    }

    func testFunc2() {
        let func2 = FuncSignature(string: "func func2(closure: (String?) -> Int?, closure2Label closure2: @escaping (String?) -> String?) -> String? {")
        XCTAssertEqual(func2.name, "func2")
        XCTAssertEqual(func2.returnType, TypeParser.parse(string: "String?"))
        XCTAssertEqual(func2.params.count, 2)
        XCTAssertEqual(func2.params[0], FuncParam(label: "closure", name: "closure", type: "(String?) -> Int?"))
        XCTAssertEqual(func2.params[1], FuncParam(label: "closure2Label", name: "closure2", type: "@escaping (String?) -> String?"))
        XCTAssertEqual(func2.rawString, "func func2(closure: (String?) -> Int?, closure2Label closure2: (String?) -> String?) -> String?")
    }

    func testFunc3() {
        let func3 = FuncSignature(string: "func func3(_ param: String)")
        XCTAssertEqual(func3.name, "func3")
        XCTAssertEqual(func3.returnType, SwiftType.Void)
        XCTAssertEqual(func3.params.count, 1)
        XCTAssertEqual(func3.params[0], FuncParam(label: "_", name: "param", type: "String"))
    }

    func testFunc4() {
        let func4 = FuncSignature(string: "func func4() {")
        XCTAssertEqual(func4.name, "func4")
        XCTAssertEqual(func4.returnType, SwiftType.Void)
        XCTAssertEqual(func4.params.count, 0)
    }
}
