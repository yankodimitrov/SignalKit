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
    
    internal fileprivate(set) var items = [RemovalToken: Item]()
    fileprivate var tokenCounter: UInt8 = 0
    fileprivate var tokenPrefix = ""
    
    @discardableResult mutating func insert(_ item: Item) -> RemovalToken {
        
        let token = nextToken()
        
        items[token] = item
        
        return token
    }
    
    mutating func remove(with token: RemovalToken) {
        
        items.removeValue(forKey: token)
    }
    
    mutating func removeAll() {
        
        items.removeAll(keepingCapacity: false)
    }
    
    fileprivate mutating func nextToken() -> RemovalToken {
        
        if tokenCounter >= UInt8.max {
            
            tokenPrefix += String(tokenCounter)
            tokenCounter = 0
        }
        
        tokenCounter += 1
        
        return tokenPrefix + String(tokenCounter)
    }
}

extension Bag: Sequence {
    
    typealias Iterator = DictionaryIterator<RemovalToken, Item>
    
    func makeIterator() -> DictionaryIterator<RemovalToken, Item> {
        
        return items.makeIterator()
    }
}
