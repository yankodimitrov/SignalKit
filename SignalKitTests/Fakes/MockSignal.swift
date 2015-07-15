//
//  MockSignal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

class MockSignal: SignalType {
    
    var sourceSignal: SignalType?
    var disposed = false
    
    func addDisposable(disposable: Disposable) {}
    
    func dispose() {
        
        disposed = true
    }
}
