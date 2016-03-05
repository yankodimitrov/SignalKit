//
//  MockDisposable.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation
@testable import SignalKit

class MockDisposable: Disposable {
    
    var isDisposeCalled = false
    
    func dispose() {
        
        isDisposeCalled = true
    }
}
