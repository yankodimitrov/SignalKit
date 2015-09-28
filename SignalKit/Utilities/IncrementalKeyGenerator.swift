//
//  IncrementalKeyGenerator.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

/**
    Generates an incremental unique sequence of tokens based on the
    number of generated tokens and a step limit.
    For example a generator with step limit of <3> will produce
    the following sequence of tokens:

    ["1", "2", "3", "31", "32", "33", "331"...].
*/
internal struct IncrementalKeyGenerator: TokenGeneratorType {
    
    internal let stepLimit: UInt16
    
    private var counter: UInt16 = 0
    private var tokenPrefix = ""
    
    private var token: Token {
        return tokenPrefix + String(counter)
    }
    
    init(stepLimit: UInt16) {
        
        guard stepLimit > 0 else {
            
            self.stepLimit = UInt16.max
            return
        }
        
        self.stepLimit = stepLimit
    }
    
    init() {
        
        self.init(stepLimit: UInt16.max)
    }
    
    mutating func nextToken() -> Token {
        
        if counter >= stepLimit {
            
            tokenPrefix += String(stepLimit)
            counter = 0
        }
        
        counter += 1
        
        return token
    }
}
