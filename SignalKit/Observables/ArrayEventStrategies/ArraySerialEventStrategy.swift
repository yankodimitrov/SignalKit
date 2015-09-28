//
//  ArraySerialEventStrategy.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 9/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

internal final class ArraySerialEventStrategy: ArrayEventStrategyType {
    
    internal let dispatcher: Dispatcher<ObservableArrayEvent>
    
    init(dispatcher: Dispatcher<ObservableArrayEvent>) {
        
        self.dispatcher = dispatcher
    }
    
    func insertedElementsAtIndex(index: Int, count: Int) {
        
        let event = ObservableArrayEvent.Insert(Set(index..<index + count))
        
        dispatcher.dispatch(event)
    }
    
    func updatedElementAtIndex(index: Int) {
        
        let event = ObservableArrayEvent.Update(Set([index]))
        
        dispatcher.dispatch(event)
    }
    
    func removedElementAtIndex(index: Int) {
        
        let event = ObservableArrayEvent.Remove(Set([index]))
        
        dispatcher.dispatch(event)
    }
    
    func replacedAllElements() {
        
        let event = ObservableArrayEvent.Reset
        
        dispatcher.dispatch(event)
    }
}
