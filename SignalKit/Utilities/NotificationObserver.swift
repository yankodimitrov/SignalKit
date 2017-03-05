//
//  NotificationObserver.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

final class NotificationObserver: NSObject {
    
    fileprivate let center: NotificationCenter
    fileprivate let name: String
    fileprivate weak var object: AnyObject?
    fileprivate var disposeAction: Disposable?
    
    var notificationCallback: ((Notification) -> Void)?
    
    init(center: NotificationCenter, name: String, object: AnyObject? = nil) {
        
        self.center = center
        self.name = name
        self.object = object
        
        super.init()
        
        center.addObserver(self, selector: #selector(NotificationObserver.handleNotification(_:)), name: NSNotification.Name(rawValue: name), object: object)
        
        disposeAction = DisposableAction { [weak self, weak object] in
            
            guard let theSelf = self else { return }
            
            center.removeObserver(theSelf, name: NSNotification.Name(rawValue: name), object: object)
        }
    }
    
    func handleNotification(_ notification: Notification) {
        
        notificationCallback?(notification)
    }
    
    deinit {
        
        dispose()
    }
}

// MARK: - Disposable

extension NotificationObserver: Disposable {
    
    func dispose() {
        
        notificationCallback = nil
        disposeAction?.dispose()
        disposeAction = nil
    }
}
