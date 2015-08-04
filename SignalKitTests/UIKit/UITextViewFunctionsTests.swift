//
//  UITextViewFunctionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class UITextViewFunctionsTests: XCTestCase {

    let center = NSNotificationCenter.defaultCenter()
    var textView: UITextView!
    var signalsBag: SignalBag!
    
    override func setUp() {
        super.setUp()
        
        textView = UITextView()
        signalsBag = SignalBag()
    }
    
    func testObserveTextInTextView() {
        
        var result = ""
        
        observe(textIn: textView)
            .next { result = $0 }
            .addTo(signalsBag)
        
        textView.text = "Jack"
        center.postNotificationName(UITextViewTextDidChangeNotification, object: textView)
        
        XCTAssertEqual(result, "Jack", "Should observe the text in UITextView")
    }
    
    func testObserveTextInTextViewCurrentText() {
        
        var result = ""
        
        textView.text = "Jack"
        
        observe(textIn: textView)
            .next { result = $0 }
            .addTo(signalsBag)
        
        XCTAssertEqual(result, "Jack", "Should contain the current text from the UITextView")
    }
    
    func testObserveAttributedTextInTextView() {
        
        var result = NSAttributedString(string: "")
        
        observe(attributedTextIn: textView)
            .next { result = $0 }
            .addTo(signalsBag)
        
        textView.attributedText = NSAttributedString(string: "Jack")
        center.postNotificationName(UITextViewTextDidChangeNotification, object: textView)
        
        XCTAssertEqual(result.string, "Jack", "Should observe the attributed text in UITextView")
    }
    
    func testObserveAttributedTextInTextViewCurrentAttributedText() {
        
        var result = NSAttributedString(string: "")
        
        textView.attributedText = NSAttributedString(string: "Jack")
        
        observe(attributedTextIn: textView)
            .next { result = $0 }
            .addTo(signalsBag)
        
        XCTAssertEqual(result.string, "Jack", "Should contain the current attributed text from the UITextView")
    }
    
    func testBindToTextIn() {
        
        let name = ObservableOf<String>()
        
        name.dispatch("Jack")
        
        observe(name)
            .bindTo(textIn(textView))
            .addTo(signalsBag)
        
        XCTAssertEqual(textView.text, "Jack", "Should bind a String value to the text property of UITextView")
    }
    
    func testBindToAttributedTextIn() {
        
        let name = ObservableOf<NSAttributedString>()
        let attributedText = NSAttributedString(string: "Jack")
        
        name.dispatch(attributedText)
        
        observe(name)
            .bindTo(attributedTextIn(textView))
            .addTo(signalsBag)
        
        XCTAssertEqual(textView.attributedText.string, "Jack", "Should bind a NSAttributedString to the attributedText property of UITextView")
    }
}
