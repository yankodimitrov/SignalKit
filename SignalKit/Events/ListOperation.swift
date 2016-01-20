//
//  ListOperation.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/20/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public enum ListOperation {
    
    case Reset
    case Insert(index: Int)
    case Update(index: Int)
    case Remove(index: Int)
}
