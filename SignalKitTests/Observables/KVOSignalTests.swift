//
//  KVOSignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class KVOSignalTests: XCTestCase {
    
    var person: Person!
    
    override func setUp() {
        super.setUp()
        
        person = Person(name: "John")
    }
    
    func testObserveForKeyPath() {
        
        let signal = KVOSignal<String>(subject: person, keyPath: "name")
        var result = ""
        
        signal.addObserver { result = $0 }
        
        person.name = "Jane"
        
        XCTAssertEqual(result, "Jane", "Should observe NSObject for key path using KVO")
    }
    
    func testDisposeObservation() {
        
        let signal = KVOSignal<String>(subject: person, keyPath: "name")
        var result = ""
        
        signal.addObserver { result = $0 }
        signal.dispose()
        
        person.name = "Jane"
        
        XCTAssertEqual(result, "", "Should dispose the observation")
    }
    
    func testDisposeTheDisposableSource() {
        
        let disposableSource = MockDisposable()
        
        let signal = KVOSignal<String>(subject: person, keyPath: "name")
        
        signal.disposableSource = disposableSource
        
        signal.dispose()
        
        XCTAssertEqual(disposableSource.isDisposeCalled, true, "Should call the disposable source to dispose")
    }
    
    func testObserveValueForKeyPathContext() {
        
        var otherContext = 0
        let observer = KVOObserver(subject: person, keyPath: "name")
        var isCalled = false
        
        observer.callback = { _ in isCalled = true }
        
        observer.observeValueForKeyPath("name", ofObject: person, change: [NSKeyValueChangeNewKey: "Jane"], context: &otherContext)
        
        XCTAssertEqual(isCalled, false, "Should dispatch changes only from the same context")
    }
    
    func testDeinit() {
        
        var result = ""
        var signal: KVOSignal<String>? = KVOSignal<String>(subject: person, keyPath: "name")
        
        signal?.addObserver { result = $0 }
        signal = nil
        
        person.name = "John"
        
        XCTAssertEqual(result, "", "Should dispose the observation upon deinit")
    }
}
