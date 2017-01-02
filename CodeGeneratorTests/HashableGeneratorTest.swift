//
//  HashableGeneratorTest.swift
//  CodeGenerator
//
//  Created by WANG Jie on 02/01/2017.
//  Copyright © 2017 wangjie. All rights reserved.
//

import XCTest
@testable import CodeGenerator

class HashableGeneratorTest: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEquatableGenerator() {
        let source = string(from: "EquatableClazz", ofType: "txt")
        let interface = InterfaceSignature(interfaceSource: source, lines: source.components(separatedBy: "\n"))
        let hashableeGenerator = HashableGenerator(interfaceSignature: interface, indentation: "    ")

        var expectedHashSource = string(from: "GeneratedHash", ofType: "txt").components(separatedBy: "\n")
        expectedHashSource.removeLast()

        XCTAssertEqual(hashableeGenerator.lines.count, expectedHashSource.count)
        let count = min(hashableeGenerator.lines.count, expectedHashSource.count)
        for i in 0..<count {
            XCTAssertEqual(hashableeGenerator.lines[i], expectedHashSource[i])
        }
    }
}
