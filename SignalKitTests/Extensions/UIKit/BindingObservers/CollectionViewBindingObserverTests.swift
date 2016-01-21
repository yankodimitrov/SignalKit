//
//  CollectionViewBindingObserverTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class CollectionViewBindingObserverTests: XCTestCase {
    
    var bindingObserver: CollectionViewBindingObserver!
    var collection: MockObservableCollection!
    var collectionView: MockCollectionView!
    
    override func setUp() {
        super.setUp()
        
        bindingObserver = CollectionViewBindingObserver()
        collection = MockObservableCollection()
        collectionView = MockCollectionView()
        
        bindingObserver.collectionView = collectionView
    }
    
    func testDisposeBindingObserver() {
        
        let fakeDisposable = MockDisposable()
        
        bindingObserver.observer = fakeDisposable
        
        bindingObserver.dispose()
        
        XCTAssertEqual(fakeDisposable.isDisposeCalled, true, "Should dispose the binding")
        XCTAssert(bindingObserver.observer == nil, "Should set the disposable observer to nil")
    }
    
    func testDisposeOnDeinit() {
        
        let fakeDisposable = MockDisposable()
        
        var bindingObserver: CollectionViewBindingObserver? = CollectionViewBindingObserver()
        
        bindingObserver?.observer = fakeDisposable
        
        bindingObserver = nil
        
        XCTAssertEqual(fakeDisposable.isDisposeCalled, true, "Should dispose on deinit")
    }
}
