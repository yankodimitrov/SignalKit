//
//  Lock.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/17.
//  Copyright © 2017 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol Lock {
    
    func lock()
    func unlock()
}
