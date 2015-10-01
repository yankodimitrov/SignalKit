//
//  MockObservable.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation
@testable import SignalKit

class MockObservable<T>: Observable {
    typealias Item = T
    
    let dispatcher: Dispatcher<Item>
    
    init() {
        
        self.dispatcher = Dispatcher<Item>()
    }
}
