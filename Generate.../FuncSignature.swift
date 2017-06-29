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
    let returnType: SwiftType

    var readableName: String {
        if params.isEmpty {
            return name
        }
        return name + params[0].readableLabel.Capitalized
    }

    var isReturnVoid: Bool {
        return returnType == SwiftType.Void
    }

    init(string: String) throws {
        guard let nameResult = "func ([\\S]*)\\(".firstMatch(in: string) else {
            throw NSError.sourceInvalid
        }
        name = string.substring(with: nameResult.rangeAt(1))

        let paramsRange = try string.paramsRange()
        let rawParams = string.substring(with: paramsRange)
        let paramsString = rawParams.paramsStrings
        params = paramsString.map { paramString in
            try? FuncParam(string: paramString.trimed)
        }.flatMap { $0 }

        let stringAfterLastParam = string.substring(from: string.index(string.startIndex, offsetBy: paramsRange.toRange()!.upperBound))

        guard let returnTypeResult = "->(.*)$".firstMatch(in: stringAfterLastParam) else {
            returnType = SwiftType.Void
            return
        }
        let returnTypeString = stringAfterLastParam.substring(with: returnTypeResult.rangeAt(1)).replacingOccurrences(of: "{", with: "").trimed
        returnType = TypeParser.parse(string: returnTypeString)
    }
}

private extension String {
    func paramsRange() throws -> NSRange {
        var startParenthesisCount = 0
        var endParenthesisCount = 0
        var paramsStartIndex: Int!
        var paramsEndIndex: Int!
        characters.enumerated().forEach { index, char in
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
            throw NSError.sourceInvalid
        }
        startIndex += 1
        return NSRange(location: startIndex, length: endIndex-startIndex)
    }

    var paramsStrings: [String] {
        var parenthesisDiff = 0
        var paramEnd = 0
        var paramsString = [String]()
        characters.enumerated().forEach { index, character in
            if character == "(" {
                parenthesisDiff += 1
            }
            if character == ")" {
                parenthesisDiff -= 1
            }
            if parenthesisDiff == 0 && character == "," {
                let start = self.index(startIndex, offsetBy: paramEnd)
                let end = self.index(startIndex, offsetBy: index)
                paramEnd = index + 1
                paramsString.append(substring(with: Range(uncheckedBounds: (lower: start, upper: end))))
            }
        }
        let lastStart = index(startIndex, offsetBy: paramEnd)
        paramsString.append(substring(with: Range(uncheckedBounds: (lower: lastStart, upper: endIndex))))
        return paramsString.filter { !$0.isEmpty }
    }
}

extension FuncSignature: Equatable {
    static func ==(l: FuncSignature, r: FuncSignature) -> Bool {
        return l.name == r.name && l.params == r.params && l.returnType == r.returnType
    }
}

extension FuncSignature {
    var rawString: String {
        let paramsString = params.map { $0.rawString }.joined(separator: ", ")
        let rawString = "func \(name)(\(paramsString))"
        if isReturnVoid {
            return rawString
        }
        return "\(rawString) -> \(returnType.name)"
    }
}
