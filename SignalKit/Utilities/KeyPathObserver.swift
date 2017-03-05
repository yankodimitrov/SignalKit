//
//  KeyPathObserver.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

private var KeyPathObserverContext = 0

final class KeyPathObserver: NSObject {
    
    fileprivate weak var subject: NSObject?
    fileprivate let keyPath: String
    fileprivate var isDisposed = false
    
    var keyPathCallback: ((AnyObject) -> Void)?
    
    init(subject: NSObject, keyPath: String) {
        
        self.subject = subject
        self.keyPath = keyPath
        
        super.init()
        
        
        subject.addObserver(self, forKeyPath: keyPath, options: .new, context: &KeyPathObserverContext)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        
        guard context == &KeyPathObserverContext,
              let value: AnyObject = change?[NSKeyValueChangeKey.newKey] as AnyObject? else {
            
            return
        }
        
        keyPathCallback?(value)
    }
    
    deinit {
        
        dispose()
    }
}

// MARK: - Disposable

extension KeyPathObserver: Disposable {
    
    func dispose() {
        
        guard !isDisposed else { return }
        
        keyPathCallback = nil
        subject?.removeObserver(self, forKeyPath: keyPath, context: &KeyPathObserverContext)
        isDisposed = true
    }
}
