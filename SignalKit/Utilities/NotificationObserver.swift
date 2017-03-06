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
    fileprivate let name: Notification.Name
    fileprivate weak var object: AnyObject?
    fileprivate var disposeAction: Disposable?
    
    var notificationCallback: ((Notification) -> Void)?
    
    init(center: NotificationCenter, name: Notification.Name, object: AnyObject? = nil) {
        
        self.center = center
        self.name = name
        self.object = object
        
        super.init()
        
        center.addObserver(self, selector: #selector(handleNotification), name: name, object: object)
        
        disposeAction = DisposableAction { [weak self, weak object] in
            
            guard let observer = self else { return }
            
            center.removeObserver(observer, name: name, object: object)
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
