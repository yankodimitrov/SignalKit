//
//  StubObservable.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

class StubObservable<T>: Observable {
    typealias Item = T
    
    let dispatcher: Dispatcher<Item>
    let disposable: Disposable
    
    init(disposable: Disposable) {
        
        self.dispatcher = Dispatcher<Item>()
        self.disposable = disposable
    }
    
    func addObserver(observer: Item -> Void) -> Disposable {
       
        return disposable
    }
}
