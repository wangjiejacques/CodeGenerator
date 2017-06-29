//
//  NSCodingGeneratorTest.swift
//  CodeGenerator
//
//  Created by WANG Jie on 25/05/2017.
//  Copyright © 2017 wangjie. All rights reserved.
//

import XCTest
@testable import CodeGenerator

class NSCodingGeneratorTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNSCodingGenerator() {
        let source = string(from: "EquatableClazz", ofType: "txt")
        let interface = try! InterfaceSignature(interfaceSource: source, lines: source.components(separatedBy: "\n"))
        let codingGenerator = CodingGenerator(interfaceSignature: interface, indentation: "    ")

        var expectedCodingSource = string(from: "GeneratedNSCoder", ofType: "txt").components(separatedBy: "\n")
        expectedCodingSource.removeLast()

        XCTAssertEqual(codingGenerator.lines.count, expectedCodingSource.count)
        let count = min(codingGenerator.lines.count, expectedCodingSource.count)
        for i in 0..<count {
            XCTAssertEqual(codingGenerator.lines[i], expectedCodingSource[i])
        }
    }

}
