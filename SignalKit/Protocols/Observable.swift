//
//  Observable.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol Observable: class {
    typealias Item
    
    func addObserver(observer: Item -> Void) -> Disposable
    func dispatch(value: Item)
    func removeObservers()
}
