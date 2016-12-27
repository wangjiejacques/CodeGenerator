//
//  EqualGeneratorTests.swift
//  CodeGenerator
//
//  Created by WANG Jie on 27/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import XCTest
@testable import CodeGenerator

class EqualGeneratorTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEqualGenerator() {
        let source = string(from: "EquatableClazz", ofType: "txt")
        let interface = InterfaceSignature(interfaceSource: source, lines: source.components(separatedBy: "\n"))
        let equalGenerator = EqualGenerator(interfaceSignature: interface, indentation: "    ")

        var expectedEqualsSource = string(from: "GeneratedEquals", ofType: "txt").components(separatedBy: "\n")
        expectedEqualsSource.removeLast()

        XCTAssertEqual(equalGenerator.lines.count, expectedEqualsSource.count)
        let count = min(equalGenerator.lines.count, expectedEqualsSource.count)
        for i in 0..<count {
            XCTAssertEqual(equalGenerator.lines[i], expectedEqualsSource[i])
        }
    }

}
