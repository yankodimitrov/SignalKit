//
//  MockDisposable.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

class MockDisposable: Disposable {
    
    var disposed = false
    
    func dispose() {
    
        disposed = true
    }
}
