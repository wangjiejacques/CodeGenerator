//
//  AccessLevelTests.swift
//  CodeGenerator
//
//  Created by WANG Jie on 27/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import XCTest
@testable import CodeGenerator

class AccessLevelTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAccessLevel1() {
        XCTAssertEqual(AccessLevel(string: " public "), AccessLevel.public)
        XCTAssertEqual(AccessLevel(string: " internal var name: String"), AccessLevel.internal)
        XCTAssertEqual(AccessLevel(string: " open func"), AccessLevel.open)
        XCTAssertEqual(AccessLevel(string: " fileprivate var"), AccessLevel.fileprivate)
        XCTAssertEqual(AccessLevel(string: " private var"), AccessLevel.private)
        XCTAssertEqual(AccessLevel(string: "public "), AccessLevel.internal)
        XCTAssertEqual(AccessLevel(string: " privatevar"), AccessLevel.internal)
    }

}
