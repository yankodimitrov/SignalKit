//
//  SignalContainerType.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol SignalContainerType {
    
    func addSignal<T: SignalType>(signal: T) -> Disposable
    func removeSignals()
}
