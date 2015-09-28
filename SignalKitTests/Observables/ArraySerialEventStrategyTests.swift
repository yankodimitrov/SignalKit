//
//  ArraySerialEventStrategyTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 9/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

internal func containsIndexes(indexes: [Int], inSet set: Set<Int>) -> Bool {
    return set.subtract(indexes).count == 0
}

class ArraySerialEventStrategyTests: XCTestCase {
    
    var strategy: ArraySerialEventStrategy!
    var dispatcher: Dispatcher<ObservableArrayEvent>!
    
    override func setUp() {
        super.setUp()
        
        let lock = MockLock()
        
        dispatcher = Dispatcher<ObservableArrayEvent>(lock: lock)
        strategy = ArraySerialEventStrategy(dispatcher: dispatcher)
    }
    
    func testInitWithDispatcher() {
        
        XCTAssert(strategy.dispatcher === dispatcher, "Should init with dispatcher")
    }
    
    func testInsertedElementsAtIndexEvent() {
        
        var result = false
        
        dispatcher.addObserver { event in
            
            if case let .Insert(indexes) = event {
                
                result = containsIndexes([0, 1], inSet: indexes)
            }
        }
        
        strategy.insertedElementsAtIndex(0, count: 2)
        
        XCTAssertEqual(result, true, "Should dispatch the inserted indexes")
    }
    
    func testUpdatedElementAtIndexEvent() {
        
        var result = false
        
        dispatcher.addObserver { event in
            
            if case let .Update(indexes) = event {
                
                result = containsIndexes([0], inSet: indexes)
            }
        }
        
        strategy.updatedElementAtIndex(0)
        
        XCTAssertEqual(result, true, "Should dispatch the updated index")
    }
    
    func testRemovedElementAtIndex() {
        
        var result = false
        
        dispatcher.addObserver { event in
            
            if case let .Remove(indexes) = event {
                
                result = containsIndexes([1], inSet: indexes)
            }
        }
        
        strategy.removedElementAtIndex(1)
        
        XCTAssertEqual(result, true, "Should dispatch the removed index")
    }
    
    func testReplacedAllElements() {
        
        var result = false
        
        dispatcher.addObserver { event in
            
            if case .Reset = event {
                
                result = true
            }
        }
        
        strategy.replacedAllElements()
        
        XCTAssertEqual(result, true, "Should dispatch .Reset event")
    }
}
