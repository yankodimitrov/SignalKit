//
//  ArrayBatchEventStrategyTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 9/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class ArrayBatchEventStrategyTests: XCTestCase {
    
    let elements = [1, 2, 3, 4]
    var strategy: ArrayBatchEventStrategy!
    
    override func setUp() {
        super.setUp()
        
        strategy = ArrayBatchEventStrategy(elementsCount: elements.count)
    }
    
    func testInitWithElementsCount() {
        
        let expectedIndexes = [0, 1, 2 ,3]
        
        XCTAssertEqual(strategy.indexes, expectedIndexes, "Should generate indexes")
    }
    
    func testInitiallyEmptyBatchEvent() {
        
        var isEmpty = false
        
        if case let .Batch(inserted, updated, removed) = strategy.event {
            
            if inserted.isEmpty && updated.isEmpty && removed.isEmpty {
                isEmpty = true
            }
        }
        
        XCTAssertEqual(isEmpty, true, "Should return empty .Batch event")
    }
    
    func testInsertedElementsAtIndex() {
        
        var containsInsertedIndex = false
        
        strategy.insertedElementsAtIndex(0, count: 1)
        
        if case let .Batch(inserted, updated, removed) = strategy.event {
            
            if inserted.contains(0) && updated.isEmpty && removed.isEmpty {
                containsInsertedIndex = true
            }
        }
        
        XCTAssertEqual(containsInsertedIndex, true, "Should contain the inserted index")
    }
    
    func testInsertedElementsAtIndexMultipleElements() {
        
        var containsInsertedIndexes = false
        
        strategy.insertedElementsAtIndex(0, count: 2)
        
        if case let .Batch(inserted, updated, removed) = strategy.event {
            
            if inserted.subtract([0, 1]).count == 0 &&
                updated.isEmpty &&
                removed.isEmpty {
                    
                    containsInsertedIndexes = true
            }
        }
        
        XCTAssertEqual(containsInsertedIndexes, true, "Should contain the inserted indexes")
    }
    
    func testInsertedElementsAtIndexReturnsOnCollectionReset() {
        
        var containsInsertedIndex = false
        
        strategy.replacedAllElements()
        strategy.insertedElementsAtIndex(1, count: 2)
        
        if case let .Batch(inserted, _, _) = strategy.event {
            
            if inserted.subtract([1, 2]).count == 0 {
                
                containsInsertedIndex  = true
            }
        }
        
        XCTAssertEqual(containsInsertedIndex, false, "Should return if the collection has been reset")
    }
    
    func testUpdatedElementAtIndex() {
        
        var containsUpdatedIndex = false
        
        strategy.updatedElementAtIndex(1)
        
        if case let .Batch(inserted, updated, deleted) = strategy.event {
            
            if updated.subtract([1]).count == 0 &&
                inserted.isEmpty &&
                deleted.isEmpty {
                    
                    containsUpdatedIndex = true
            }
        }
        
        XCTAssertEqual(containsUpdatedIndex, true, "Should contain the updated index")
    }
    
    func testUpdatedElementAtIndexMultipleElements() {
        
        var containsUpdatedIndex = false
        
        strategy.updatedElementAtIndex(1)
        strategy.updatedElementAtIndex(0)
        
        if case let .Batch(inserted, updated, deleted) = strategy.event {
            
            if updated.subtract([0,1]).count == 0 &&
                inserted.isEmpty &&
                deleted.isEmpty {
                    
                    containsUpdatedIndex = true
            }
        }
        
        XCTAssertEqual(containsUpdatedIndex, true, "Should contain the updated indexes")
    }
    
    func testUpdatedElementAtIndexReturnsWhenUpdatingAnInsertedIndex() {
        
        var containsUpdatedIndex = false
        
        strategy.insertedElementsAtIndex(1, count: 1)
        strategy.updatedElementAtIndex(1)
        
        if case let .Batch(_, updated, _) = strategy.event {
            
            if updated.contains(1) {
                
                containsUpdatedIndex = true
            }
        }
        
        XCTAssertEqual(containsUpdatedIndex, false, "Should return if updating an inserted item index")
    }
    
    func testUpdatedElementAtReturnsOnCollectionReset() {
        
        var containsUpdatedIndex = false
        
        strategy.replacedAllElements()
        strategy.updatedElementAtIndex(1)
        
        if case let .Batch(_, updated, _) = strategy.event {
            
            if updated.subtract([1]).count == 0 {
                
                containsUpdatedIndex = true
            }
        }
        
        XCTAssertEqual(containsUpdatedIndex, false, "Should return if the collection has been reset")
    }
    
    func testRemovedElementAtIndex() {
        
        var containsRemovedIndex = false
        
        strategy.removedElementAtIndex(0)
        
        if case let .Batch(inserted, updated, removed) = strategy.event {
            
            if removed.subtract([0]).count == 0 &&
                inserted.isEmpty &&
                updated.isEmpty {
                    
                    containsRemovedIndex = true
            }
        }
        
        XCTAssertEqual(containsRemovedIndex, true, "Should contain the removed index")
    }
    
    func testRemovedElementAtIndexMultipleElements() {
        
        var containsRemovedIndex = false
        
        strategy.removedElementAtIndex(0)
        strategy.removedElementAtIndex(0)
        
        if case let .Batch(inserted, updated, removed) = strategy.event {
            
            if removed.subtract([0, 1]).count == 0 &&
                inserted.isEmpty &&
                updated.isEmpty {
                    
                    containsRemovedIndex = true
            }
        }
        
        XCTAssertEqual(containsRemovedIndex, true, "Should contain the removed indexes")
    }
    
    func testRemovedElementAtIndexWillRemoveInsertedIndex() {
        
        var isEmptyEvent = false
        
        strategy.insertedElementsAtIndex(0, count: 1)
        strategy.removedElementAtIndex(0)
        
        if case let .Batch(inserted, updated, removed) = strategy.event {
            
            if inserted.isEmpty && updated.isEmpty && removed.isEmpty {
                
                isEmptyEvent = true
            }
        }
        
        XCTAssertEqual(isEmptyEvent, true, "Should remove the inserted index from the set with inserted indexes")
    }
    
    func testRemovedElementAtIndexWillRemoveUpdatedIndex() {
        
        var isEmptyEvent = false
        
        strategy.updatedElementAtIndex(1)
        strategy.removedElementAtIndex(1)
        
        if case let .Batch(inserted, updated, removed) = strategy.event {
            
            if removed.subtract([1]).count == 0 &&
                inserted.isEmpty &&
                updated.isEmpty {
                    
                    isEmptyEvent = true
            }
        }
        
        XCTAssertEqual(isEmptyEvent, true, "Should remove the updated index from the set with updated indexes")
    }
    
    func testRemovedElementAtIndexReturnsOnCollectionReset() {
        
        var containsUpdatedIndex = false
        
        strategy.replacedAllElements()
        strategy.removedElementAtIndex(0)
        
        if case let .Batch(_, updated, _) = strategy.event {
            
            if updated.contains(1) {
                
                containsUpdatedIndex = true
            }
        }
        
        XCTAssertEqual(containsUpdatedIndex, false, "Should return if the collection has been reset")
    }
    
    func testReplacedAllElements() {
        
        var isResetEvent = false
        
        strategy.replacedAllElements()
        
        if case .Reset = strategy.event {
            isResetEvent = true
        }
        
        XCTAssertEqual(isResetEvent, true, "Should return .Reset event")
    }
    
    func testInsertUpdateAndRemoveOnTheSameIndexWillResultInNoOperation() {
        
        var isEmptyEvent = false
        
        strategy.insertedElementsAtIndex(0, count: 1)
        strategy.updatedElementAtIndex(0)
        strategy.removedElementAtIndex(0)
        
        if case let .Batch(inserted, updated, removed) = strategy.event {
            
            if removed.isEmpty && inserted.isEmpty && updated.isEmpty {
                
                isEmptyEvent = true
            }
        }
        
        XCTAssertEqual(isEmptyEvent, true, "Should contain empty batch event when we perfom insert(0), update(0) and remove(0)")
    }
    
    func testFirstSequenceOfOperations() {
        
        var containsTheIndexes = false
        
        strategy.removedElementAtIndex(1)
        strategy.insertedElementsAtIndex(0, count: 1)
        strategy.updatedElementAtIndex(1)
        strategy.removedElementAtIndex(0)
        
        if case let .Batch(inserted, updated, removed) = strategy.event {
            
            if updated.subtract([0]).count == 0 &&
                removed.subtract([1]).count == 0 &&
                inserted.isEmpty {
                    
                    containsTheIndexes = true
            }
        }
        
        XCTAssertEqual(containsTheIndexes, true, "Should contain the removed{0} and updated{1}")
    }
    
    func testSecondSequenceOfOperations() {
        
        var containsTheIndexes = false
        
        strategy.insertedElementsAtIndex(0, count: 3)
        strategy.removedElementAtIndex(0)
        strategy.updatedElementAtIndex(3)
        
        if case let .Batch(inserted, updated, removed) = strategy.event {
            
            if inserted.subtract([0, 1]).count == 0 &&
                updated.subtract([1]).count == 0 &&
                removed.isEmpty {
                    
                    containsTheIndexes = true
            }
        }
        
        XCTAssertEqual(containsTheIndexes, true, "Should contain the inserted{0,1} and updated{1}")
    }
    
    func testThirdSequenceOfOperations() {
        
        var containsTheIndexes = false
        
        strategy.updatedElementAtIndex(1)
        strategy.removedElementAtIndex(0)
        strategy.removedElementAtIndex(0)
        strategy.insertedElementsAtIndex(2, count: 1)
        
        if case let .Batch(inserted, updated, removed) = strategy.event {
            
            if inserted.subtract([2]).count == 0 &&
                updated.isEmpty &&
                removed.subtract([0,1]).count == 0 {
                    
                    containsTheIndexes = true
            }
        }
        
        XCTAssertEqual(containsTheIndexes, true, "Should contain the inserted{2} and removed{0,1}")
    }
    
    func testFourthSequenceOfOperations() {
        
        var containsTheIndexes = false
        
        strategy.insertedElementsAtIndex(0, count: 1)
        strategy.insertedElementsAtIndex(0, count: 2)
        
        if case let .Batch(inserted, updated, removed) = strategy.event {
            
            if inserted.subtract([0, 1, 2]).count == 0 &&
                updated.isEmpty &&
                removed.isEmpty {
                    
                    containsTheIndexes = true
            }
        }
        
        XCTAssertEqual(containsTheIndexes, true, "Should contain the inserted{0, 1, 2}")
    }
    
    func testFifthSequenceOfOperations() {
        
        var containsTheIndexes = false
        
        strategy.updatedElementAtIndex(3)
        strategy.insertedElementsAtIndex(1, count: 1)
        strategy.removedElementAtIndex(2)
        strategy.insertedElementsAtIndex(0, count: 1)
        strategy.removedElementAtIndex(1)
        strategy.updatedElementAtIndex(0)
        
        if case let .Batch(inserted, updated, removed) = strategy.event {
            
            if inserted.subtract([0, 1]).count == 0 &&
                updated.subtract([3]).count == 0 &&
                removed.subtract([0, 1]).count == 0 {
                    
                    containsTheIndexes = true
            }
        }
        
        XCTAssertEqual(containsTheIndexes, true, "Should contain the inserted{0, 1}, updated{3} and removed{0, 1}")
    }
    
    func testSixthSequenceOfOperations() {
        
        var containsTheIndexes = false
        
        strategy.removedElementAtIndex(0)
        strategy.removedElementAtIndex(0)
        strategy.removedElementAtIndex(0)
        strategy.removedElementAtIndex(0)
        strategy.insertedElementsAtIndex(0, count: 2)
        strategy.updatedElementAtIndex(1)
        
        if case let .Batch(inserted, updated, removed) = strategy.event {
            
            if inserted.subtract([0, 1]).count == 0 &&
                updated.isEmpty &&
                removed.subtract([0, 1, 2, 3]).count == 0 {
                    
                    containsTheIndexes = true
            }
        }
        
        XCTAssertEqual(containsTheIndexes, true, "Should contain the inserted{0, 1} and removed{0, 1, 2 ,3}")
    }
}
