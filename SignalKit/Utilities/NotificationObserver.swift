//
//  NotificationObserver.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

final class NotificationObserver: NSObject {
    
    private let center: NSNotificationCenter
    private let name: String
    private weak var object: AnyObject?
    private var disposeAction: Disposable?
    
    var notificationCallback: (NSNotification -> Void)?
    
    init(center: NSNotificationCenter, name: String, object: AnyObject? = nil) {
        
        self.center = center
        self.name = name
        self.object = object
        
        super.init()
        
        center.addObserver(self, selector: "handleNotification:", name: name, object: object)
        
        disposeAction = DisposableAction { [weak self, weak object] in
            
            guard let theSelf = self else { return }
            
            center.removeObserver(theSelf, name: name, object: object)
        }
    }
    
    func handleNotification(notification: NSNotification) {
        
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
