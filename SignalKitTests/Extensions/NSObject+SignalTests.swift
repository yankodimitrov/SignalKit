//
//  NSObject+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/15/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class NSObject_SignalTests: XCTestCase {
    
    var person: Person!
    var signalsBag: SignalBag!
    
    override func setUp() {
        super.setUp()
        
        person = Person(name: "")
        signalsBag = SignalBag()
    }
    
    func testObserveKeyPath() {
        
        var result = ""
        
        person.observe()
            .keyPath("name", value: "")
            .next { result = $0 }
            .addTo(signalsBag)
        
        person.name = "John"
        
        XCTAssertEqual(result, "John", "Should observe NSObject for certain key path updates")
    }
    
    func testObserveKeyPathSendInitialValue() {
        
        var result = ""
        
        person.observe()
            .keyPath("name", value: "Jack")
            .next { result = $0 }
            .addTo(signalsBag)
        
        XCTAssertEqual(result, "Jack", "Should send the initial value")
    }
}
