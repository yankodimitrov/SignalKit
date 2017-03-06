//
//  ControlEventObserver.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

final class ControlEventObserver: NSObject {
    
    fileprivate weak var control: UIControl?
    fileprivate let events: UIControlEvents
    fileprivate var disposeAction: Disposable?
    var eventCallback: ((UIControl) -> Void)?
    
    init(control: UIControl, events: UIControlEvents) {
        
        self.control = control
        self.events = events
        
        super.init()
        
        control.addTarget(self, action: #selector(handleEvent), for: events)
        
        disposeAction = DisposableAction { [weak self] in
            
            self?.control?.removeTarget(self, action: #selector(self?.handleEvent), for: events)
        }
    }
    
    func handleEvent() {
        
        guard let control = control else { return }
        
        eventCallback?(control)
    }
    
    deinit {
        
        dispose()
    }
}

// MARK: - Disposable

extension ControlEventObserver: Disposable {
    
    func dispose() {
        
        eventCallback = nil
        disposeAction?.dispose()
        disposeAction = nil
    }
}
