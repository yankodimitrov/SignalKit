//
//  NSIndexSet+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 9/30/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

internal extension NSIndexSet {
    
    convenience init(withSet set: Set<Int>) {
        
        let indexSet = NSMutableIndexSet()
        
        for index in set {
            
            indexSet.addIndex(index)
        }
        
        self.init(indexSet: indexSet)
    }
}
