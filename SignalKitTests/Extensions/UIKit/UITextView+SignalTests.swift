//
//  UITextView+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UITextView_SignalTests: XCTestCase {
    
    let center = NSNotificationCenter.defaultCenter()
    var textView: UITextView!
    var signalsBag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        textView = UITextView()
        signalsBag = DisposableBag()
    }
    
    func testObserveText() {
        
        var result = ""
        
        textView.observe().text
            .next { result = $0 }
            .disposeWith(signalsBag)
        
        textView.text = "John"
        center.postNotificationName(UITextViewTextDidChangeNotification, object: textView)
        
        XCTAssertEqual(result, "John", "Should observe for text changes in UITextView")
    }
    
    func testObserveCurrentText() {
        
        var result = ""
        
        textView.text = "John"
        
        textView.observe().text
            .next { result = $0 }
            .disposeWith(signalsBag)
        
        XCTAssertEqual(result, "John", "Should dispatch the current text from UITextView")
    }
    
    func testObserveAttributedText() {
        
        var result = NSAttributedString(string: "")
        let newText = NSAttributedString(string: "John")
        
        textView.observe().attributedText
            .next { result = $0 }
            .disposeWith(signalsBag)
        
        textView.attributedText = newText
        center.postNotificationName(UITextViewTextDidChangeNotification, object: textView)
        
        XCTAssertEqual(result.string, "John", "Should observe for attributed text changes in UITextView")
    }
    
    func testObserveCurrentAttributedText() {
        
        var result = NSAttributedString(string: "")
        let newText = NSAttributedString(string: "John")
        
        textView.attributedText = newText
        
        textView.observe().attributedText
            .next { result = $0 }
            .disposeWith(signalsBag)
        
        XCTAssertEqual(result.string, "John", "Should dispatch the current attribured text from UITextView")
    }
    
    func testBindToText() {
        
        let signal = MockSignal<String>()
        
        signal.dispatch("Jack")
        
        signal.bindTo(textIn: textView).disposeWith(signalsBag)
        
        XCTAssertEqual(textView.text, "Jack", "Should bind a String to the text property of UITextView")
    }
    
    func testBindToAttributedText() {
        
        let signal = MockSignal<NSAttributedString>()
        let text = NSAttributedString(string: "Jack")
        
        signal.dispatch(text)
        
        signal.bindTo(attributedTextIn: textView).disposeWith(signalsBag)
        
        XCTAssertEqual(textView.attributedText.string, "Jack", "Should bind a NSAtrributedString to the attributed text property of UITextView")
    }
}
