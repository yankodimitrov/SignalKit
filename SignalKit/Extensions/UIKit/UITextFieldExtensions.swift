//
//  UITextFieldExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalEventType where Sender: UITextField {
    
    /// Observe the text changes in UITextField
    
    public var text: Signal<String> {
        
        return events(.editingChanged).map { $0.text ?? "" }
    }
}
