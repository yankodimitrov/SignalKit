//
//  KVOSignal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

private var ObserverContext = 0

public final class KVOSignal<T>: SignalType {
    
    public typealias Item = T
    public var disposableSource: Disposable?
    public let dispatcher: Dispatcher<Item>
    
    private let observer: KVOObserver
    
    public init(subject: NSObject, keyPath: String, lock: LockType? = nil) {
        
        dispatcher = Dispatcher<Item>(lock: lock)
        observer = KVOObserver(subject: subject, keyPath: keyPath)
        observer.callback = { [weak self] value in
            
            if let value = value as? Item {
                self?.dispatch(value)
            }
        }
    }
    
    deinit {
        
        dispose()
    }
    
    public func dispose() {
        
        observer.dispose()
        disposableSource?.dispose()
    }
}

internal final class KVOObserver: NSObject, Disposable {
    
    private weak var subject: NSObject?
    private let keyPath: String
    private var isDisposed = false
    internal var callback: ((value: AnyObject) -> Void)?
    init(subject: NSObject, keyPath: String) {
        
        self.subject = subject
        self.keyPath = keyPath
        
        super.init()
        
        subject.addObserver(self, forKeyPath: keyPath, options: .New, context: &ObserverContext)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        guard context == &ObserverContext, let value: AnyObject = change?[NSKeyValueChangeNewKey] else {
            return
        }
        
        callback?(value: value)
    }
    
    func dispose() {
        
        guard !isDisposed else { return }
        
        subject?.removeObserver(self, forKeyPath: keyPath)
        isDisposed = true
    }
}
