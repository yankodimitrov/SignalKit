//
//  DisposableAction.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/4/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class DisposableAction: Disposable {
    
    private var action: (() -> Void)?
    
    public init(action: () -> Void) {
        
        self.action = action
    }
}

extension DisposableAction {
    
    public func dispose() {
        
        action?()
        action = nil
    }
}
