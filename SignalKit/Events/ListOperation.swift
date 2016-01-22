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

extension ListOperation: Equatable {}

public func ==(lhs: ListOperation, rhs: ListOperation) -> Bool {
    
    switch (lhs, rhs) {
        
    case (.Reset, .Reset):
        return true
        
    case (let .Insert(a), let .Insert(b)):
        return a == b
        
    case (let .Update(a), let .Update(b)):
        return a == b
        
    case (let .Remove(a), let .Remove(b)):
        return a == b
        
    default:
        return false
    }
}

extension ListOperation: Hashable {
    
    public var hashValue: Int {
        
        switch self {
            
        case .Reset:
            return 0.hashValue
        
        case let .Insert(index):
            return 1.hashValue ^ index.hashValue
            
        case let .Update(index):
            return 2.hashValue ^ index.hashValue
            
        case let .Remove(index):
            return 3.hashValue ^ index.hashValue
        }
    }
}
