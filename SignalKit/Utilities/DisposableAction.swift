//
//  DisposableAction.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class DisposableAction: Disposable {
    
    private var action: (() -> Void)?
    
    public init(action: () -> Void) {
        
        self.action = action
    }
    
    public func dispose() {
        
        action?()
        action = nil
    }
}
