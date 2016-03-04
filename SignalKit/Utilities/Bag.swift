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
    private var tokenCounter: UInt8 = 0
    private var tokenPrefix = ""
    
    mutating func insertItem(item: Item) -> RemovalToken {
        
        let removalToken = nextRemovalToken()
        
        items[removalToken] = item
        
        return removalToken
    }
    
    mutating func removeItemWithToken(token: RemovalToken) {
        
        items.removeValueForKey(token)
    }
    
    mutating func removeAll() {
        
        items.removeAll(keepCapacity: false)
    }
    
    private mutating func nextRemovalToken() -> RemovalToken {
        
        if tokenCounter >= UInt8.max {
            
            tokenPrefix += String(tokenCounter)
            tokenCounter = 0
        
        }
        
        tokenCounter += 1
        
        return tokenPrefix + String(tokenCounter)
    }
}

extension Bag: SequenceType {
    
    func generate() -> DictionaryGenerator<RemovalToken, Item> {
        
        return items.generate()
    }
}
