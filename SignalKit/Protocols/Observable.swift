//
//  Observable.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol Observable {
    typealias Item
    
    var dispatcher: ObserversDispatcher<Item> {get}
    
    func addObserver(observer: Item -> Void) -> Disposable
    func dispatch(item: Item)
    func removeObservers()
}

public extension Observable {
    
    public func addObserver(observer: Item -> Void) -> Disposable {
        
        return dispatcher.addObserver(observer)
    }
    
    public func dispatch(item: Item) {
        
        dispatcher.dispatch(item)
    }
    
    public func removeObservers() {
        
        dispatcher.removeObservers()
    }
}
