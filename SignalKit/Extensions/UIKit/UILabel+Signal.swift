//
//  UILabel+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalType where Item == String {
    
    /**
        Bind a String to the text property of UILabel
    
    */
    public func bindTo(textIn label: UILabel) -> Self {
        
        addObserver { [weak label] in
            
            label?.text = $0
        }
        
        return self
    }
}

public extension SignalType where Item == NSAttributedString {
    
    /**
        Bind a NSAttributedString to the atrributedText property of UILabel
    
    */
    public func bindTo(attributedTextIn label: UILabel) -> Self {
        
        addObserver { [weak label] in
            
            label?.attributedText = $0
        }
        
        return self
    }
}
