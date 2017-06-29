//
//  VarSignatureTests.swift
//  CodeGenerator
//
//  Created by WANG Jie on 25/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import XCTest
@testable import CodeGenerator

class VarSignatureTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testVar1() {
        let var1 = VarSignature(string: "  var name: String?")
        XCTAssertEqual(var1, VarSignature(declaration: "var", name: "name", type: "String?"))
    }

    func testVar2() {
        let var2 = VarSignature(string: "   let name: (String) -> Bool?")
        XCTAssertEqual(var2, VarSignature(declaration: "let", name: "name", type: "(String) -> Bool?"))
    }

    func testVar3() {
        let var3 = VarSignature(string: "  var name: (String?, Bool) -> (String, Bool?) { get set }")
        XCTAssertEqual(var3, VarSignature(declaration: "var", name: "name", type: "(String?, Bool) -> (String, Bool?)"))
    }

    func testVarArray() {
        let varArray = VarSignature(string: " var name: [String]?")
        XCTAssertEqual(varArray, VarSignature(declaration: "var", name: "name", type: "[String]?"))
    }
}
