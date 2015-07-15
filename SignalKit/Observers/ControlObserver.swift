//
//  ControlObserver.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

final class ControlObserver<T: UIControl>: Disposable {
    
    private weak var control: T?
    private let events: UIControlEvents
    private let callback: T -> Void
    private var disposed = false
    
    private lazy var target: ControlEventTarget = {
        
        let target = ControlEventTarget { [weak self] in
        
            self?.eventHandler()
        }
        
        return target
    }()
    
    init(observe control: T, events: UIControlEvents, callback: T -> Void) {
        
        self.control = control
        self.events = events
        self.callback = callback
        
        control.addTarget(target, action: "eventHandler", forControlEvents: events)
    }
    
    deinit {
        
        dispose()
    }
    
    private func eventHandler() {
        
        if let control = control {
            
            callback(control)
        }
    }
    
    func dispose() {
        
        if disposed {
            return
        }
        
        control?.removeTarget(target, action: "eventHandler", forControlEvents: events)
        disposed = true
    }
}

final class ControlEventTarget: NSObject {
    
    let eventCallback: () -> Void
    
    init(callback: () -> Void) {
        
        eventCallback = callback
        
        super.init()
    }
    
    func eventHandler() {
        
        eventCallback()
    }
}
