//
//  NSObject+file.swift
//  CodeGenerator
//
//  Created by WANG Jie on 26/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

extension NSObject {

    func string(from path: String, ofType type: String) -> String {
        let path = Bundle(for: type(of: self)).path(forResource: path, ofType: type)!
        return try! String(contentsOfFile: path)
    }
}
