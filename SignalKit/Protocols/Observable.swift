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
    
    func addObserver(observer: Item -> Void) -> Disposable
    func dispatch(item: Item)
    func removeObservers()
}
