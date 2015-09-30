//
//  ArrayBindingObserverTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 9/30/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class ArrayBindingObserverTests: XCTestCase {
    
    var array: ObservableArray<ObservableArray<Int>>!
    var bindingObserver: ArrayBindingObserver<Int>!
    var strategy: MockBindingStrategy!
    
    override func setUp() {
        super.setUp()
        
        let sectionOne = ObservableArray([1, 2])
        let sectionTwo = ObservableArray([3, 4])
        
        array = ObservableArray([sectionOne, sectionTwo])
        strategy = MockBindingStrategy()
        
        bindingObserver = ArrayBindingObserver(array: array)
        bindingObserver.bindingStrategy = strategy
    }
    
    func testObserveSectionsReset() {
        
        array.replaceElementsWith([])
        
        XCTAssertEqual(strategy.isReloadAllSectionsCalled, true, "Should call the strategy to reload all sections")
    }
    
    func testObserveSectionsInsert() {
        
        let expectedSections = NSIndexSet(index: 0)
        var result = false
        
        strategy.sectionsInsertCallback = { (sections: NSIndexSet) in
            
            if sections.containsIndexes(expectedSections) {
                result = true
            }
        }
        
        array.insert(ObservableArray([55]), atIndex: 0)
        
        XCTAssertEqual(result, true, "Should call the strategy to insert sections")
    }
    
    func testObserveSectionsReload() {
        
        let expectedSections = NSIndexSet(index: 1)
        var result = false
        
        strategy.sectionsReloadCallback = { (sections: NSIndexSet) in
            
            if sections.containsIndexes(expectedSections) {
                result = true
            }
        }
        
        array[1] = ObservableArray([55])
        
        XCTAssertEqual(result, true, "Should call the strategy to reload sections")
    }
    
    func testObserveSectionsDelete() {
        
        let expectedSections = NSIndexSet(index: 0)
        var result = false
        
        strategy.sectionsDeleteCallback = { (sections: NSIndexSet) in
            
            if sections.containsIndexes(expectedSections) {
                result = true
            }
        }
        
        array.removeAtIndex(0)
        
        XCTAssertEqual(result, true, "Should call the strategy to delete sections")
    }
    
    func testObserveSectionsBatchUpdate() {
        
        array.performBatchUpdate { collection in
            
            collection.removeAtIndex(0)
        }
        
        XCTAssertEqual(strategy.isBatchUpdateCalled, true, "Should call the strategy to perform batch update")
    }
    
    func testObserveNewSections() {
        
        let newSection = ObservableArray([5, 6, 7])
        let expectedPaths = [NSIndexPath(forItem: 1, inSection: 2)]
        var result = false
        
        strategy.rowsDeleteCallback = { paths in
            
            if paths == expectedPaths {
                result = true
            }
        }
        
        array.append(newSection)
        array[2].removeAtIndex(1)
        
        XCTAssertEqual(result, true, "Should setup observers for the newly inserted sections")
    }
    
    func testObserveRowsReset() {
        
        let expectedSection = NSIndexSet(index: 0)
        var result = false
        
        strategy.reloadRowsInSectionCallback = { (sections: NSIndexSet) in
            
            if sections.containsIndexes(expectedSection) {
                result = true
            }
        }
        
        array[0].replaceElementsWith([11, 22, 33])
        
        XCTAssertEqual(result, true, "Should call the strategy to reload rows in section")
    }
    
    func testObserveRowsInsert() {
        
        let expectedPaths = [NSIndexPath(forItem: 2, inSection: 0)]
        var result = false
        
        strategy.rowsInsertCallback = { paths in
            
            if paths == expectedPaths {
                result = true
            }
        }
        
        array[0].insert(3, atIndex: 2)
        
        XCTAssertEqual(result, true, "Should call the strategy to insert rows in section")
    }
    
    func testObserveRowsReload() {
        
        let expectedPaths = [NSIndexPath(forItem: 0, inSection: 1)]
        var result = false
        
        strategy.rowsReloadCallback = { paths in
            
            if paths == expectedPaths {
                result = true
            }
        }
        
        array[1][0] = 44
        
        XCTAssertEqual(result, true, "Should call the strategy to reload rows in section")
    }
    
    func testObserveRowsDelete() {
        
        let expectedPaths = [NSIndexPath(forItem: 1, inSection: 1)]
        var result = false
        
        strategy.rowsDeleteCallback = { paths in
            
            if paths == expectedPaths {
                result = true
            }
        }
        
        array[1].removeAtIndex(1)
        
        XCTAssertEqual(result, true, "Should call the strategy to delete rows in section")
        
    }
    
    func testObserveRowsBatchUpdate() {
        
        array[0].performBatchUpdate { collection in
            
            collection.removeAtIndex(0)
        }
        
        XCTAssertEqual(strategy.isBatchUpdateCalled, true, "Should call the strategy to perform batch update")
    }
    
    func testDispose() {
        
        bindingObserver.dispose()
        
        array.replaceElementsWith([])
        
        XCTAssertEqual(strategy.isReloadAllSectionsCalled, false, "Should dispose the observation upon disposal")
        
    }
    
    func testDeinit() {
        
        var observer: ArrayBindingObserver? = ArrayBindingObserver(array: array)
        let fakeStrategy = MockBindingStrategy()
        
        observer?.bindingStrategy = fakeStrategy
        observer = nil
        
        array.replaceElementsWith([])
        
        XCTAssertEqual(fakeStrategy.isReloadAllSectionsCalled, false, "Should dispose the observation upon deinit")
    }
}
