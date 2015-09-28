//
//  ObservableArrayTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 9/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class ObservableArrayTests: XCTestCase {

    var list: ObservableArray<Int>!
    
    override func setUp() {
        super.setUp()
        
        list = ObservableArray<Int>()
    }
    
    func testInitWithElementsAndLock() {
        
        let elements = [1, 2]
        let lock = MockLock()
        let list = ObservableArray<Int>(elements: elements, lock: lock)
        
        XCTAssertEqual(list.elements, elements, "Should init with elements and lock")
    }
    
    func testInitWithElements() {
        
        let elements = [1, 2]
        let list = ObservableArray<Int>(elements)
        
        XCTAssertEqual(list.elements, elements, "Should init with elements")
    }
    
    func testInit() {
        
        let list = ObservableArray<Int>()
        
        XCTAssertEqual(list.elements.count, 0, "Should init with no elements")
    }
    
    func testInsertElementsAtIndex() {
        
        let elements = [1, 2]
        
        list.insertElements(elements, atIndex: 0)
        
        XCTAssertEqual(list.elements, elements, "Should insert elements at index")
    }
    
    func testReplaceElementAtIndex() {
        
        list.elements = [1, 2]
        
        list.replaceElementAtIndex(0, withElement: 3)
        
        let element = list.elements[0]
        
        XCTAssertEqual(element, 3, "Should repalce element at index")
    }
}
