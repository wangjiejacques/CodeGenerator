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
        let type1 = SwiftType(string: "Bool")
        XCTAssertEqual(type1.name, "Bool")
        XCTAssertEqual(type1.unwrappedName, "Bool")
        XCTAssertEqual(type1.isOptional, false)
        XCTAssertEqual(type1.isClosure, false)
        XCTAssertEqual(type1.optionalName, "Bool?")
    }

    func testType2() {
        let type2 = SwiftType(string: "String?")
        XCTAssertEqual(type2.name, "String?")
        XCTAssertEqual(type2.unwrappedName, "String")
        XCTAssertEqual(type2.isClosure, false)
        XCTAssertEqual(type2.isOptional, true)
        XCTAssertEqual(type2.optionalName, "String?")
    }

    func testType3() {
        let type3 = SwiftType(string: "(String?) -> String?")
        XCTAssertEqual(type3.name, "(String?) -> String?")
        XCTAssertEqual(type3.unwrappedName, "(String?) -> String?")
        XCTAssertEqual(type3.isOptional, false)
        XCTAssertEqual(type3.isClosure, true)
        XCTAssertEqual(type3.optionalName, "((String?) -> String?)?")
    }
}
