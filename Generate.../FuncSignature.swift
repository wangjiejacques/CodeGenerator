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
        name = string.substring(with: nameResult.range(at: 1))

        let paramsRange = try string.paramsRange()
        let rawParams = String(string[paramsRange])
        let paramsString = rawParams.paramsStrings
        params = paramsString.map { paramString in
            try? FuncParam(string: paramString.trimed)
        }.flatMap { $0 }
        let stringAfterLastParam = String(string[paramsRange.upperBound...])

        guard let returnTypeResult = "->(.*)$".firstMatch(in: stringAfterLastParam) else {
            returnType = SwiftType.Void
            return
        }
        let returnTypeString = stringAfterLastParam.substring(with: returnTypeResult.range(at: 1)).replacingOccurrences(of: "{", with: "").trimed
        returnType = TypeParser.parse(string: returnTypeString)
    }
}

private extension String {
    func paramsRange() throws -> Range<String.Index> {
        var startParenthesisCount = 0
        var endParenthesisCount = 0
        var paramsStartIndex: Int!
        var paramsEndIndex: Int!
        enumerated().forEach { index, char in
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

        guard var startIntIndex = paramsStartIndex, let endIntIndex = paramsEndIndex else {
            throw NSError.sourceInvalid
        }
        startIntIndex += 1
        let startIndex = index(self.startIndex, offsetBy: startIntIndex)
        let endIndex = index(self.startIndex, offsetBy: endIntIndex)
        return startIndex..<endIndex
    }

    var paramsStrings: [String] {
        var parenthesisDiff = 0
        var paramEnd = 0
        var paramsString = [String]()
        enumerated().forEach { index, character in
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
                paramsString.append(String(self[start..<end]))
            }
        }
        let lastStart = index(startIndex, offsetBy: paramEnd)
        paramsString.append(String(self[lastStart..<endIndex]))
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
