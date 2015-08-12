//
//  ObserversDispatcher.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class ObserversDispatcher<Item> {
    
    private let dispatchRule: (Item) -> () -> Item?
    private var dispatchValue: ( () -> Item? )?
    
    private lazy var observers = Bag<Item -> Void>()
    private var lock: LockType?
    
    internal var observersCount: Int {
        return observers.count
    }
    
    /**
        Initialize with custom dispatch rule
    
        The dispatch rule is used to determine if the observable should
        dispatch the latest value to the newly added observer.
    
    */
    public init(dispatchRule: (Item) -> () -> Item?, lock: LockType? = nil) {
        
        self.dispatchRule = dispatchRule
        self.lock = lock
    }
    
    /**
        Initialize with dispatch rule that stores strongly
        the latest dispatched item and sends it immediately
        to any new added observers
    
    */
    public convenience init(lock: LockType? = nil) {
        
        self.init(dispatchRule: { v in { return v } }, lock: lock)
    }
    
    public func addObserver(observer: Item -> Void) -> Disposable {
        
        var token = ""
        
        performAtomicAction {
            
            token = self.observers.insert(observer)
            
            if let value = self.dispatchValue?() {
                
                observer(value)
            }
        }
        
        return DisposableAction { [weak self] in
            
            self?.performAtomicAction {
                
                self?.observers.removeItemWithToken(token)
            }
        }
    }
    
    public func dispatch(item: Item) {
        
        performAtomicAction {
            
            for (_, observer) in self.observers {
                
                observer(item)
            }
            
            self.dispatchValue = self.dispatchRule(item)
        }
    }
    
    public func removeObservers() {
        
        performAtomicAction {
            
            self.observers.removeItems()
        }
    }
    
    private func performAtomicAction(action: () -> Void) {
        
        lock?.lock()
        
        action()
        
        lock?.unlock()
    }
}
