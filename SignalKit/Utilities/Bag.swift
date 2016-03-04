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
    
    mutating func insertItem(item: Item) -> RemovalToken {
        
        let removalToken = nextRemovalToken()
        
        items[removalToken] = item
        
        return removalToken
    }
    
    private func nextRemovalToken() -> RemovalToken {
        
        return "0"
    }
}
