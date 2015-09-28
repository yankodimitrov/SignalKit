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
    
    func testRemoveElementAtIndex() {
        
        list.elements = [1, 2]
        
        let element = list.removeElementAtIndex(0)
        
        XCTAssertEqual(list.elements.count, 1, "Should remove element at index")
        XCTAssertEqual(element, 1, "Should contain the removed element")
    }
    
    func testRemoveAllElements() {
        
        list.elements = [1, 2]
        
        list.removeAllElements()
        
        XCTAssertEqual(list.elements.isEmpty, true, "Should remove all elements")
    }
    
    func testStartIndex() {
        
        XCTAssertEqual(list.startIndex, list.elements.startIndex, "Should return the elements start index")
    }
    
    func testEndIndex() {
        
        XCTAssertEqual(list.endIndex, list.elements.endIndex, "Should return the elements end index")
    }
    
    func testIsEmpty() {
       
        XCTAssertEqual(list.isEmpty, list.elements.isEmpty, "Should return the elements isEmpty value")
    }
    
    func testCount() {
        
        XCTAssertEqual(list.count, list.elements.count, "Should return the elements count")
    }
    
    func testUnderestimateCount() {
        
        XCTAssertEqual(list.underestimateCount(), list.elements.underestimateCount(), "Should return the elements underestimate count value")
    }
    
    func testGenerate() {
        
        var count = 0
        let array = ObservableArray<ObservableArray<Int>>()
        let first = ObservableArray([1, 2])
        let second = ObservableArray([3, 4])
        
        array.elements = [first, second]
        
        for section in array {
            
            for value in section {
                count += value
            }
        }
        
        XCTAssertEqual(count, 10, "Should return IndexingGenerator for the elements")
    }
    
    func testSubscriptGet() {
        
        list.elements = [1, 2]
        
        let element = list[1]
        
        XCTAssertEqual(element, 2, "Should return the element at index 1")
    }
    
    func testSubscriptUpdate() {
        
        list.elements = [1, 2]
        
        list[0] = 3
        
        XCTAssertEqual(list.elements[0], 3, "Should update the element at index")
    }
    
    func testAppend() {
        
        let newElement = 111
        
        list.elements = [1, 2, 3]
        list.append(newElement)
        
        let element = list[3]
        
        XCTAssertEqual(list.count, 4, "Should append the element")
        XCTAssertEqual(element, newElement, "Should append the element")
    }
    
    func testAppendContentsOf() {
        
        let newElements = [11, 22]
        
        list.elements = [1, 2, 3]
        list.appendContentsOf(newElements)
        
        XCTAssertEqual(list.count, 5, "Should append the elements")
        XCTAssertEqual(list[3], 11, "Should contain the newly appended element")
        XCTAssertEqual(list[4], 22, "Should contain the newly appended element")
    }
    
    func testSubrange() {
        
        list.elements = [1, 2, 3]
        
        let elements = list[0...1]
        
        XCTAssertEqual(elements, list.elements[0...1], "Should return the sub range array slice")
    }
}
