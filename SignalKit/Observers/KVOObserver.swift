//
//  KVOObserver.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

private var ObserverContext = 0

final class KVOObserver: NSObject, Disposable {
    
    private weak var subject: NSObject?
    private let keyPath: String
    private let callback: AnyObject -> Void
    private var disposed = false
    
    init(observe subject: NSObject, keyPath: String, callback: AnyObject -> Void) {
        
        self.subject = subject
        self.keyPath = keyPath
        self.callback = callback
        
        super.init()
        
        subject.addObserver(self, forKeyPath: keyPath, options: .New, context: &ObserverContext)
    }
    
    deinit {
        
        dispose()
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if context == &ObserverContext {
            
            if let value: AnyObject = change[NSKeyValueChangeNewKey] {
                
                callback(value)
            }
        }
    }
    
    func dispose() {
        
        if disposed {
            return
        }
        
        subject?.removeObserver(self, forKeyPath: keyPath)
        disposed = true
    }
}
