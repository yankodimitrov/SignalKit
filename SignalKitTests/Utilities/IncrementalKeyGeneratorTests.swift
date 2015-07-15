//
//  IncrementalKeyGeneratorTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class IncrementalKeyGeneratorTests: XCTestCase {
    
    func testGenerateToken() {
        
        var generator = IncrementalKeyGenerator()
        
        let token = generator.nextToken() // "1"
        
        XCTAssertEqual(token, "1", "First token should be equal to 1")
    }
    
    func testGenerateIncrementalTokens() {
        
        var generator = IncrementalKeyGenerator(stepLimit: 2)
        
        generator.nextToken() // "1"
        generator.nextToken() // "2"
        
        let token = generator.nextToken() // "21"
        
        XCTAssertEqual(token, "21", "Should generate an incremental sequence of tokens")
    }
}
