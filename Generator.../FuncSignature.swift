//
//  FuncSignature.swift
//  CodeGenerator
//
//  Created by WANG Jie on 25/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

private let wrongFuncFormat = "func format incorrect"

struct FuncSignature {
    let name: String
    let params: [FuncParam]
    let returnType: String

    var readableName: String {
        if params.isEmpty {
            return name
        }
        return name + params[0].label.capitalized
    }

    var isReturnVoid: Bool {
        return returnType == "Void"
    }

    init(string rawString: String) {
        let string = rawString.replacingOccurrences(of: "@escaping", with: "")
        guard let nameResult = "func ([\\S]*)\\(".firstMatch(in: string) else {
            preconditionFailure(wrongFuncFormat)
        }
        name = string.substring(with: nameResult.rangeAt(1))

        var startParenthesisCount = 0
        var endParenthesisCount = 0
        var paramsStartIndex: Int?
        var paramsEndIndex: Int?
        string.characters.enumerated().forEach { index, char in
            if char == "(" {
                startParenthesisCount += 1
                if paramsStartIndex == nil {
                    paramsStartIndex = index
                }
            }
            if char == ")" {
                endParenthesisCount += 1
            }
            if startParenthesisCount != 0 && startParenthesisCount == endParenthesisCount {
                if paramsEndIndex == nil {
                    paramsEndIndex = index
                }
            }
        }

        guard var startIndex = paramsStartIndex, let endIndex = paramsEndIndex else {
            preconditionFailure(wrongFuncFormat)
        }
        startIndex += 1
        let rawParams = string.substring(with: NSRange(location: startIndex, length: endIndex-startIndex))
        let paramsString = rawParams.components(separatedBy: ",")
        params = paramsString.map { FuncParam(string: $0) }.flatMap { $0 }

        guard let returnTypeResult = "->([^>]*)\\{".firstMatch(in: string) else {
            returnType = "Void"
            return
        }
        returnType = string.substring(with: returnTypeResult.rangeAt(1)).trimed
    }
}

extension FuncSignature: Equatable {
    static func ==(l: FuncSignature, r: FuncSignature) -> Bool {
        return l.name == r.name && l.params == r.params && l.returnType == r.returnType
    }
}
