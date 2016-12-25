//
//  SwiftSourceTests.swift
//  CodeGenerator
//
//  Created by WANG Jie on 25/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import XCTest
@testable import CodeGenerator

class SwiftSourceTests: XCTestCase {

    var swiftSource: SwiftSource!
    
    override func setUp() {
        super.setUp()
        let source = "//TestClass.swift|import xxx| var global: String|class TestClass{| var var1: String| static var var2: String| private var var3: String| let var4: String?| func func1(param1: String) {\n|xxxx|var funcVar: String| } | func func2(param2: Bool) -> Bool {| return false|}"
        swiftSource = SwiftSource(source: source, lines: source.components(separatedBy: "|"))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSourceDefinition() {
        XCTAssertEqual(swiftSource.definition, SourceDefinition(lines: swiftSource.lines))
    }

    func testSourceFuncsSignatures() {
        XCTAssertEqual(swiftSource.funcSignatures, ["func func1(param1: String) ", "func func2(param2: Bool) -> Bool "].map { FuncSignature(string: $0) })
    }

    func testVarSignatures() {
        XCTAssertEqual(swiftSource.varSignatures.count, 2)
        XCTAssertEqual(swiftSource.varSignatures, ["var var1: String", "let var4: String?"].map { VarSignature(string: $0) })
    }

}
