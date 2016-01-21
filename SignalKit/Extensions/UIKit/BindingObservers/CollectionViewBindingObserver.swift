//
//  CollectionViewBindingObserver.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

internal final class CollectionViewBindingObserver {
    
    internal weak var collectionView: UICollectionView?
    internal var observer: Disposable?
}
