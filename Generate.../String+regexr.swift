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
        guard let result = "\\S.*\\S".firstMatch(in: self) else {
            return ""
        }
        return substring(with: result.range)
    }

    func count(of char: Character) -> Int {
        var count = 0
        characters.forEach { c in
            if c == char {
                count += 1
            }
        }
        return count
    }

    func repeating(_ count: Int) -> String {
        return Array(repeating: self, count: count).joined()
    }

    /// Capitalized the first letter
    var Capitalized: String {
        guard !isEmpty else { return "" }
        
        let range = Range(uncheckedBounds: (lower: startIndex, upper: index(after: startIndex)))
        return replacingCharacters(in: range, with: substring(with: range).uppercased())
    }
}
