//
//  Bag.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

/**
    An unordered non unique collection of items.

*/
internal struct Bag<Item> {
    
    private var items = [Token: Item]()
    private var generator: TokenGeneratorType
    
    var count: Int {
        return items.count
    }
    
    init(keyGenerator: TokenGeneratorType) {
        
        generator = keyGenerator
    }
    
    init() {
        
        self.init(keyGenerator: IncrementalKeyGenerator())
    }
    
    mutating func insert(item: Item) -> Token {
        
        let token = generator.nextToken()
        
        items[token] = item
        
        return token
    }
    
    mutating func removeItemWithToken(token: Token) {
        
        items.removeValueForKey(token)
    }
    
    mutating func removeItems() {
        
        items.removeAll(keepCapacity: false)
    }
}

extension Bag: SequenceType {
    
    func generate() -> DictionaryGenerator<Token, Item> {
        
        return items.generate()
    }
}
