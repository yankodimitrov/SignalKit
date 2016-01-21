//
//  UICollectionView+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UICollectionView_SignalTests: XCTestCase {

    var collection: MockObservableCollection!
    var signalsBag: DisposableBag!
    var collectionView: MockCollectionView!
    
    override func setUp() {
        super.setUp()
        
        collection = MockObservableCollection()
        signalsBag = DisposableBag()
        collectionView = MockCollectionView()
    }
    
    func testBindToTableView() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.insertItemsInRange(0..<2, inSection: 0)
        
        collection.observe()
            .bindTo(collectionView: collectionView)
            .disposeWith(signalsBag)
        
        collection.changeSetSignal.dispatch(changeSet)
        
        XCTAssertEqual(collectionView.isInsertItemsCalled, true, "Should bind the collection changes to collection view")
    }
}
