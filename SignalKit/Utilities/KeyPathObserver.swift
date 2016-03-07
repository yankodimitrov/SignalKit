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
    
    private weak var subject: NSObject?
    private let keyPath: String
    private var isDisposed = false
    
    var keyPathCallback: (AnyObject -> Void)?
    
    init(subject: NSObject, keyPath: String) {
        
        self.subject = subject
        self.keyPath = keyPath
        
        super.init()
        
        
        subject.addObserver(self, forKeyPath: keyPath, options: .New, context: &KeyPathObserverContext)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String: AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        guard context == &KeyPathObserverContext,
              let value: AnyObject = change?[NSKeyValueChangeNewKey] else {
            
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
