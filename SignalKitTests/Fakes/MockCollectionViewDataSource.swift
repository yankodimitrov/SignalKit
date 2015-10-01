//
//  MockCollectionViewDataSource.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 10/1/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

class MockCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
