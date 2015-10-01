//
//  UICollectionView+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 10/1/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UICollectionView_SignalTests: XCTestCase {

    var list: ObservableArray<Int>!
    var collectionView: MockCollectionView!
    var signalsBag: DisposableBag!
    var dataSource: MockCollectionViewDataSource!
    
    override func setUp() {
        super.setUp()
        
        list = ObservableArray([1, 2, 3])
        collectionView = MockCollectionView()
        signalsBag = DisposableBag()
        dataSource = MockCollectionViewDataSource()
    }
    
    func testBindToTableView() {
        
        list.observe()
            .bindTo(collectionView: collectionView, dataSource: dataSource)
            .addTo(signalsBag)
        
        list.append(4)
        
        XCTAssertEqual(collectionView.isInsertItemsCalled, true, "Should bind the changes in observable array to collection view")
        XCTAssertEqual(collectionView.isReloadDataCalled, true, "Should call the collection view to reload data")
        XCTAssert(collectionView.dataSource === dataSource, "Should set the collection view data source")
    }
}
