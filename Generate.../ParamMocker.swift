//
//  ParamMocker.swift
//  CodeGenerator
//
//  Created by WANG Jie on 28/12/2016.
//  Copyright © 2016 wangjie. All rights reserved.
//

import Foundation

protocol ParamMocker {

    var variables: [VarSignature] { get }

    var lines: [String] { get }
}
