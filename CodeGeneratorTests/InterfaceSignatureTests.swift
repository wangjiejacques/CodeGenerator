//
//  InterfaceSignatureTests.swift
//  CodeGenerator
//
//  Created by WANG Jie on 25/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import XCTest
@testable import CodeGenerator

class InterfaceSignatureTests: XCTestCase {

    var interfaceSignature: InterfaceSignature!
    
    override func setUp() {
        super.setUp()
        let source = "//TestClass.swift|import xxx| var global: String|class TestClass{| var var1: String| static var var2: String| private var var3: String| let var4: String?| func func1(param1: String) {\n|xxxx|var funcVar: String| } | func func2(param2: Bool) -> Bool {| return false|}"
        interfaceSignature = try! InterfaceSignature(interfaceSource: source, lines: source.components(separatedBy: "|"))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInterfaceDefinition() {
        XCTAssertEqual(interfaceSignature.definition, try! InterfaceDefinition(lines: interfaceSignature.lines))
    }

    func testSourceFuncsSignatures() {
        XCTAssertEqual(interfaceSignature.funcSignatures, ["func func1(param1: String) ", "func func2(param2: Bool) -> Bool "].map { try! FuncSignature(string: $0) })
    }

    func testVarSignatures() {
        let vars = [" var var1: String", " private var var3: String", " let var4: String?"].map { VarSignature(string: $0)! }
        XCTAssertEqual(interfaceSignature.varSignatures.count, vars.count)
        for i in 0..<vars.count {
            XCTAssertEqual(interfaceSignature.varSignatures[i], vars[i])
        }
        XCTAssertEqual(interfaceSignature.varSignatures[1].accessLevel, .private)
        XCTAssertEqual(interfaceSignature.varSignatures[0].accessLevel, .internal)
    }

}
