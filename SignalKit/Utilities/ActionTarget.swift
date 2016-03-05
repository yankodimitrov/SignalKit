//
//  ActionTarget.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

final class ActionTarget: NSObject {
    
    var disposeAction: Disposable?
    var actionCallback: (AnyObject -> Void)?
    let actionSelector = "handleAction:"
    
    func handleAction(sender: AnyObject) {
        
        actionCallback?(sender)
    }
    
    deinit {
        
        dispose()
    }
}

// MARK: - Disposable

extension ActionTarget: Disposable {
    
    func dispose() {
        
        disposeAction?.dispose()
        disposeAction = nil
    }
}
