//
//  Bag.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/4/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

typealias RemovalToken = String

struct Bag<Item> {
    
    internal private(set) var items = [RemovalToken: Item]()
    
}
