//
//  String+regexr.swift
//  MockGenerator
//
//  Created by WANG Jie on 11/10/2016.
//  Copyright © 2016 jwang123. All rights reserved.
//

import Foundation

extension String {
    func matches(in string: String) -> [NSTextCheckingResult] {
        let regex = try! NSRegularExpression(pattern: self)
        return regex.matches(in: string, options: [], range: NSRange(0 ..< string.characters.count))
    }

    func firstMatch(in string: String) -> NSTextCheckingResult? {
        let regex = try! NSRegularExpression(pattern: self)
        return regex.firstMatch(in: string, options: [], range: NSRange(0 ..< string.characters.count))
    }

    func substring(with range: NSRange) -> String {
        return (self as NSString).substring(with: range)
    }

    var spaceRemoved: String {
        return replacingOccurrences(of: " ", with: "")
    }

    /// remove the space at the begining and at the end
    var trimed: String {
        return substring(with: "\\S.*\\S".firstMatch(in: self)!.range)
    }
}
