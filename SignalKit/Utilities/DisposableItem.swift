//
//  DisposableItem.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class DisposableItem: Disposable {
    
    private var action: (() -> Void)?
    
    public init(action: () -> Void) {
        
        self.action = action
    }
    
    public func dispose() {
        
        action?()
        action = nil
    }
}
