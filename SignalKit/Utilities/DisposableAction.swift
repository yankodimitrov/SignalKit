//
//  DisposableAction.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/4/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class DisposableAction: Disposable {
    
    fileprivate var action: (() -> Void)?
    
    public init(action: @escaping () -> Void) {
        
        self.action = action
    }
}

extension DisposableAction {
    
    public func dispose() {
        
        action?()
        action = nil
    }
}
