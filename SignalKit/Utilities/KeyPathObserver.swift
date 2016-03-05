//
//  KeyPathObserver.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

private var KeyPathObserverContext = 0

final class KeyPathObserver: NSObject {
    
    private weak var subject: NSObject?
    private let keyPath: String
    private var disposeAction: Disposable?
    
    var keyPathCallback: (AnyObject -> Void)?
    
    init(subject: NSObject, keyPath: String) {
        
        self.subject = subject
        self.keyPath = keyPath
        
        super.init()
        
        subject.addObserver(self, forKeyPath: keyPath, options: .New, context: &KeyPathObserverContext)
        
        disposeAction = DisposableAction { [weak self] in
            
            guard let theSelf = self else { return }
            
            subject.removeObserver(theSelf, forKeyPath: keyPath)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String: AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        guard context == &KeyPathObserverContext,
              let value: AnyObject = change?[NSKeyValueChangeNewKey] else {
            
            return
        }
        
        keyPathCallback?(value)
    }
    
    deinit {
        
        dispose()
    }
}

// MARK: - Disposable

extension KeyPathObserver: Disposable {
    
    func dispose() {
        
        disposeAction?.dispose()
        disposeAction = nil
    }
}
