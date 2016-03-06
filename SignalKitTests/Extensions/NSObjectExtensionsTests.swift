//
//  NSObjectExtensionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class NSObjectExtensionsTests: XCTestCase {

    var bag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        bag = DisposableBag()
    }
    
    func testObserveKeyPath() {
        
        let person = Person(name: "")
        var result = ""
        
        person.observe()
            .keyPath("name", value: person.name)
            .next { result = $0 }
            .disposeWith(bag)
        
        person.name = "John"
        
        XCTAssertEqual(result, "John", "Should observe the key path for new values")
    }
}
