//
//  SwiftTypeTests.swift
//  CodeGenerator
//
//  Created by WANG Jie on 26/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import XCTest
@testable import CodeGenerator

class SwiftTypeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testType1() {
        let type1 = TypeParser.parse(string: "Bool")
        XCTAssertEqual(type1.name, "Bool")
        XCTAssertEqual(type1.unwrappedName, "Bool")
        XCTAssertEqual(type1.isOptional, false)
        XCTAssertEqual(type1 is ClosureType, false)
        XCTAssertEqual(type1.optionalName, "Bool?")
    }

    func testType2() {
        let type2 = TypeParser.parse(string: "String?")
        XCTAssertEqual(type2.name, "String?")
        XCTAssertEqual(type2.unwrappedName, "String")
        XCTAssertEqual(type2 is ClosureType, false)
        XCTAssertEqual(type2.isOptional, true)
        XCTAssertEqual(type2.optionalName, "String?")
    }

    func testType3() {
        let type3 = TypeParser.parse(string: "@escaping @autoclosure (String?) -> String?")
        XCTAssertEqual(type3.name, "(String?) -> String?")
        XCTAssertEqual(type3.rawString, "@escaping @autoclosure (String?) -> String?")
        XCTAssertEqual(type3.unwrappedName, "(String?) -> String?")
        XCTAssertEqual(type3.isOptional, false)
        XCTAssertEqual(type3 is ClosureType, true)
        XCTAssertEqual(type3.optionalName, "((String?) -> String?)?")
    }

    func testType4() {
        let type3 = TypeParser.parse(string: "@escaping @autoclosure ((String?) -> String?)?")
        XCTAssertEqual(type3.name, "((String?) -> String?)?")
        XCTAssertEqual(type3.rawString, "@escaping @autoclosure ((String?) -> String?)?")
        XCTAssertEqual(type3.unwrappedName, "(String?) -> String?")
        XCTAssertEqual(type3.isOptional, true)
        XCTAssertEqual(type3 is ClosureType, true)
        XCTAssertEqual(type3.optionalName, "((String?) -> String?)?")
    }

    func testClosureType() {
        let closureType = ClosureType(rawString: "@escaping @autoclosure ((String?, Int) -> String?)?")
        XCTAssertEqual(closureType.inTypes[0], TypeParser.parse(string: "String?"))
        XCTAssertEqual(closureType.inTypes[1], TypeParser.parse(string: "Int"))
        XCTAssertEqual(closureType.outType, TypeParser.parse(string: "String?"))
    }

    func testClosureType1() {
        let closureType = ClosureType(rawString: "@escaping @autoclosure (String?, Int) -> String?")
        XCTAssertEqual(closureType.inTypes[0], TypeParser.parse(string: "String?"))
        XCTAssertEqual(closureType.inTypes[1], TypeParser.parse(string: "Int"))
        XCTAssertEqual(closureType.outType, TypeParser.parse(string: "String?"))
    }
}
