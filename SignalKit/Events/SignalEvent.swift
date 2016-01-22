//
//  SignalEvent.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/15/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public struct SignalEvent<T>: SignalEventType {
    public typealias Sender = T
    
    public let sender: Sender
}
