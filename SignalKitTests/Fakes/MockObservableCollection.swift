//
//  MockObservableCollection.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation
import SignalKit

class MockObservableCollection: ObservableCollectionType {
    
    let changeSetSignal: Signal<CollectionChangeSet>
    
    init() {
        
        changeSetSignal = Signal()
    }
}
