//
//  SourceError.swift
//  CodeGenerator
//
//  Created by WANG Jie on 29/06/2017.
//  Copyright © 2017 wangjie. All rights reserved.
//

import Foundation

extension NSError {
    static let sourceInvalid = NSError(domain: "com.wangjie.CodeGenerator.Generate", code: -1, userInfo: [NSLocalizedDescriptionKey: "source invalid"])
}
