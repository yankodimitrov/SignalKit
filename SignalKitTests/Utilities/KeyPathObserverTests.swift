//
//  KeyPathObserverTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class KeyPathObserverTests: XCTestCase {
    
    var person: Person!
    
    override func setUp() {
        super.setUp()
        
        person = Person(name: "Jack")
    }
    
    func testObserveKeyPath() {
        
        let observer = KeyPathObserver(subject: person, keyPath: "name")
        var result = ""
        
        observer.keyPathCallback = { value in
            
            if let value = value as? String {
                
                result = value
            }
        }
        
        person.name = "John"
        
        XCTAssertEqual(result, "John", "Should observe the keyPath for new values")
    }
    
    func testDispose() {
        
        let observer = KeyPathObserver(subject: person, keyPath: "name")
        var result = ""
        
        observer.keyPathCallback = { value in
            
            if let value = value as? String {
                
                result = value
            }
        }
        
        observer.dispose()
        
        person.name = "John"
        
        XCTAssertEqual(result, "", "Should dispose the observation")
    }
    
    func testObserveValueForKeyPathContext() {
        
        var otherContext = 0
        let observer = KeyPathObserver(subject: person, keyPath: "name")
        var isCalled = false
        
        observer.keyPathCallback = { _ in isCalled = true }
        
        observer.observeValueForKeyPath("name", ofObject: person, change: [NSKeyValueChangeNewKey: "Jane"], context: &otherContext)
        
        XCTAssertEqual(isCalled, false, "Should call the callback only when the event is from the same context")

    }
}
