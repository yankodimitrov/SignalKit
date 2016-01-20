//
//  CollectionChangeSetTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/20/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class CollectionChangeSetTests: XCTestCase {

    func testReplacedAllSections() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.replacedAllSections()
        
        let operations = changeSet.collectionOperations
        
        XCTAssertEqual(operations.contains(.Reset), true, "Should insert a .Reset operation")
    }
    
}
