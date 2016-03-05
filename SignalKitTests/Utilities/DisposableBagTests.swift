//
//  DisposableBagTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class DisposableBagTests: XCTestCase {
    
    func testInsertItem() {
        
        let bag = DisposableBag()
        let item = MockDisposable()
        
        bag.insertItem(item)
        
        XCTAssertEqual(bag.disposables.items.count, 1, "Should insert a disposable item")
    }
    
    func testDisposeItem() {
        
        let bag = DisposableBag()
        let item = MockDisposable()
        
        let disposableAction = bag.insertItem(item)
        
        disposableAction.dispose()
        
        XCTAssertEqual(bag.disposables.items.isEmpty, true, "Should remove the item")
    }
    
    func testDispose() {
        
        let bag = DisposableBag()
        let itemA = MockDisposable()
        let itemB = MockDisposable()
        
        bag.insertItem(itemA)
        bag.insertItem(itemB)
        
        bag.dispose()
        
        XCTAssertEqual(itemA.isDisposeCalled, true, "Should dispose item A")
        XCTAssertEqual(itemB.isDisposeCalled, true, "Should dispose item B")
        XCTAssertEqual(bag.disposables.items.isEmpty, true, "Should remove all items")
    }
}
