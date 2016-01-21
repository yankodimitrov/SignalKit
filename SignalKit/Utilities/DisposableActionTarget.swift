//
//  DisposableActionTarget.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class DisposableActionTarget: NSObject {
    
    internal private(set) var callback: (AnyObject -> Void)?
    
    public var actionSelector: Selector {
        
        return "handleAction:"
    }
    
    public init(actionCallback: AnyObject -> Void) {
        
        callback = actionCallback
    }
    
    public func handleAction(sender sender: AnyObject) {
        
        callback?(sender)
    }
}

extension DisposableActionTarget: Disposable {
    
    public func dispose() {
        
        callback = nil
    }
}
