//
//  TokenGeneratorType.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

typealias Token = String

protocol TokenGeneratorType {
    
    mutating func nextToken() -> Token
}
