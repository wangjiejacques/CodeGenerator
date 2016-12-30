//
//  TypeParser.swift
//  CodeGenerator
//
//  Created by WANG Jie on 28/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

class TypeParser {

    static func parse(string: String) -> SwiftType {
        if string.isClosure {
            return ClosureType(rawString: string)
        }
        return SwiftType(rawString: string)
    }
}

private extension String {
    var isClosure: Bool {
        if contains("->") {
            return true
        }
        return false
    }
}
