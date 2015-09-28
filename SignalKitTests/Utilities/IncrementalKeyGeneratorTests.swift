//
//  IncrementalKeyGeneratorTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class IncrementalKeyGeneratorTests: XCTestCase {
    
    func testGenerateToken() {
        
        var generator = IncrementalKeyGenerator()
        
        let token = generator.nextToken()
        
        XCTAssertEqual(token, "1", "First generated token should be equal to 1")
    }
    
    func testGenerateIncrementalTokens() {
        
        var generator = IncrementalKeyGenerator(stepLimit: 2)
        
        generator.nextToken() // "1"
        generator.nextToken() // "2"
        
        let token = generator.nextToken() // step limit is 2 -> "21"
        
        XCTAssertEqual(token, "21", "Should generate incremental sequence of tokens")
    }
}
