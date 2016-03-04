//
//  BagTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/4/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class BagTests: XCTestCase {
    
    func testInsertItem() {
        
        var bag = Bag<Int>()
        
        let token = bag.insertItem(1)
        let item = bag.items[token]
        
        XCTAssertEqual(bag.items.count, 1, "Should insert an item")
        XCTAssertEqual(item, 1, "Should contain the inserted item")
        XCTAssertNotEqual(token, "", "Should return a removal token")
    }
    
    func testProduceRemovalTokens() {
        
        var bag = Bag<Int>()
        var token = ""
        let expectedToken = "10"
        
        for i in 0..<10 {
            
            token = bag.insertItem(i)
        }
        
        XCTAssertEqual(token, expectedToken, "Should produce incremental removal tokens")
    }
    
    func testProduceSequenceOfRemovalTokens() {
        
        var bag = Bag<Int>()
        var token = ""
        let expectedToken = "\(UInt8.max)12"
        let elementsCount = Int(UInt8.max) + 12
        
        for i in 0..<elementsCount {
            
            token = bag.insertItem(i)
        }
        
        XCTAssertEqual(token, expectedToken, "Should produce a sequence of removal tokens")
    }
    
    func testRemoveItemWithToken() {
        
        var bag = Bag<Int>()
        let token = bag.insertItem(123)
        
        bag.removeItemWithToken(token)
        
        XCTAssertEqual(bag.items.isEmpty, true, "Should remove an item with given removal token")
    }
    
    func testRemoveAll() {
        
        var bag = Bag<Int>()
        
        bag.insertItem(1)
        bag.insertItem(2)
        
        bag.removeAll()
        
        XCTAssertEqual(bag.items.isEmpty, true, "Should remove all items")
    }
    
    func testIterateOverItems() {
        
        var bag = Bag<Int>()
        var sum = 0
        
        bag.insertItem(1)
        bag.insertItem(2)
        bag.insertItem(3)
        
        for (_, item) in bag {
            
            sum += item
        }
        
        XCTAssertEqual(sum, 6, "Should iterate over the bag items")
    }
}
