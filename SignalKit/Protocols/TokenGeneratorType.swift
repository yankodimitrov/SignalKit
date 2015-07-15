//
//  TokenGeneratorType.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

internal typealias Token = String

internal protocol TokenGeneratorType {
    
    mutating func nextToken() -> Token
}
