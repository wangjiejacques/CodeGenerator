//
//  InterfaceMockerTests.swift
//  CodeGenerator
//
//  Created by WANG Jie on 26/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import XCTest
@testable import CodeGenerator

//protocol Eatable {
//    var isHot: Bool { get }
//    func eat()
//}
//
//class EatableMock: Eatable {
//    var isHot: Bool
//
//    var eatWasCalled: Bool?
//
//    func eat() {
//        eatWasCalled = true
//    }
//
//}
class InterfaceMockerTests: XCTestCase {

    var interfaceMocker: InterfaceMocker!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInterface() {
        let source = "protocol Eatable {|    var isHot: Bool { get }| func eat()|}"
        let interface = InterfaceSignature(interfaceSource: source, lines: source.components(separatedBy: "|"))
        let interfaceMocker = InterfaceMocker(interfaceSignature: interface, indentationWidth: 1)
        XCTAssertEqual(interfaceMocker.mockSource.count, 10)
    }

}
