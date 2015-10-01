//
//  ArrayEventStrategyType.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 9/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

internal protocol ArrayEventStrategyType {
    
    func insertedElementsAtIndex(index: Int, count: Int)
    func updatedElementAtIndex(index: Int)
    func removedElementAtIndex(index: Int)
    func replacedAllElements()
}
