//
//  UICollectionView+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalEventType where Sender: ObservableCollectionType {
    
    /**
        Bind the changes in ObservableCollectionType to UICollectionView
     
     */
    public func bindTo(collectionView collectionView: UICollectionView) -> Disposable {
        
        let binding = CollectionViewBindingObserver()
        
        binding.collectionView = collectionView
        binding.observeCollection(sender)
        
        return binding
    }
}
