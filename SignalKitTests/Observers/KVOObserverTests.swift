//
//  KVOObserverTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class KVOObserverTests: XCTestCase {

    var person: Person!
    
    override func setUp() {
        super.setUp()
        
        person = Person(name: "John")
    }
    
    func testObserve() {
        
        var result = ""
        
        let observer = KVOObserver(observe: person, keyPath: "name") {
            
            if let value = $0 as? String {
            
                result = value
            }
        }
        
        person.name = "Jane"
        
        XCTAssertEqual(result, "Jane", "Should observe the NSObject for the given key path")
    }
    
    func testDispose() {
        
        var result = ""
        
        let observer = KVOObserver(observe: person, keyPath: "name") {
            
            if let value = $0 as? String {
            
                result = value
            }
        }
        
        observer.dispose()
        
        person.name = "Jane"
        
        XCTAssertEqual(result, "", "Should remove the KVO observation upon disposal")
    }
}
