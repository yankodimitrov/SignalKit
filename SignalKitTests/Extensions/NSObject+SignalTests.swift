//
//  NSObject+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/15/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class NSObject_SignalTests: XCTestCase {
    
    var person: Person!
    var signalsBag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        person = Person(name: "")
        signalsBag = DisposableBag()
    }
    
    func testObserveKeyPath() {
        
        var result = ""
        
        person.observe()
            .keyPath("name", value: "")
            .next { result = $0 }
            .disposeWith(signalsBag)
        
        person.name = "John"
        
        XCTAssertEqual(result, "John", "Should observe NSObject for certain key path updates")
    }
    
    func testObserveKeyPathSendInitialValue() {
        
        var result = ""
        
        person.observe()
            .keyPath("name", value: "Jack")
            .next { result = $0 }
            .disposeWith(signalsBag)
        
        XCTAssertEqual(result, "Jack", "Should send the initial value")
    }
}
