//
//  SignalType.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol SignalType: Disposable {
    
    var sourceSignal: SignalType? {get set}
    
    func addDisposable(disposable: Disposable)
}
