//
//  SignalEventType.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol SignalEventType {
    typealias Sender
    
    var sender: Sender {get}
}
