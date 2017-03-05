//
//  DisposableBag.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class DisposableBag {
    
    internal fileprivate(set) var disposables = Bag<Disposable>()
    
    public init() {}
    
    deinit {
        
        dispose()
    }
}

extension DisposableBag {
    
    @discardableResult public func insert(_ item: Disposable) -> Disposable {
        
        let token = disposables.insert(item)
        
        return DisposableAction { [weak self] in
            
            self?.disposables.remove(with: token)
        }
    }
}

// MARK: - Disposable

extension DisposableBag: Disposable {
    
    public func dispose() {
        
        for (_, item) in disposables {
            
            item.dispose()
        }
        
        disposables.removeAll()
    }
}
