//
//  ControlEventObserver.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

final class ControlEventObserver: NSObject {
    
    private weak var control: UIControl?
    private let events: UIControlEvents
    private var disposeAction: Disposable?
    var eventCallback: (UIControl -> Void)?
    
    init(control: UIControl, events: UIControlEvents) {
        
        self.control = control
        self.events = events
        
        super.init()
        
        control.addTarget(self, action: "handleEvent", forControlEvents: events)
        
        disposeAction = DisposableAction { [weak self] in
            
            self?.control?.removeTarget(self, action: "handleEvent", forControlEvents: events)
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
        
        disposeAction?.dispose()
        disposeAction = nil
    }
}
