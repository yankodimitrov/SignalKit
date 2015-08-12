//
//  KVOSignal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

private var ObserverContext = 0

public final class KVOSignal<T>: NSObject, SignalType {
    public typealias Item = T
    
    private weak var subject: NSObject?
    private let keyPath: String
    private var isDisposed = false
    
    public var disposableSource: Disposable?
    public let dispatcher: ObserversDispatcher<Item>
    
    public init(subject: NSObject, keyPath: String, lock: LockType? = nil) {
        
        self.subject = subject
        self.keyPath = keyPath
        self.dispatcher = ObserversDispatcher<Item>(lock: lock)
        
        super.init()
        
        subject.addObserver(self, forKeyPath: keyPath, options: .New, context: &ObserverContext)
    }
    
    deinit {
        
        dispose()
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        guard context == &ObserverContext, let value: AnyObject = change?[NSKeyValueChangeNewKey] else {
            return
        }
        
        if let value = value as? Item {
            
            dispatch(value)
        }
    }
    
    public func dispose() {
        
        guard !isDisposed else { return }
        
        subject?.removeObserver(self, forKeyPath: keyPath)
        isDisposed = true
        
        disposableSource?.dispose()
    }
}
