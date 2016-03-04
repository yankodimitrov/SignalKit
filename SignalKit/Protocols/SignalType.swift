//
//  SignalType.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/4/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol SignalType: Observable, Disposable {
    
    var disposableSource: Disposable? {get set}
}
