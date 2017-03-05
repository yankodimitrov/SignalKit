//
//  SignalEvent.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public struct SignalEvent<T>: Event {
    
    public typealias Sender = T
    
    public let sender: T
}
