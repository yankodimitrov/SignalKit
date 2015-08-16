//
//  UIImageView+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class UIImageView_SignalTests: XCTestCase {
    
    var imageView: UIImageView!
    var signalsBag: SignalBag!
    
    override func setUp() {
        super.setUp()
        
        imageView = UIImageView()
        signalsBag = SignalBag()
    }
    
    func testBindToImageInImageView() {
        
        let image = UIImage()
        let signal = MockSignal<UIImage?>()
        
        signal.bindTo(imageIn: imageView).addTo(signalsBag)
        
        signal.dispatch(image)
        
        XCTAssert(imageView.image! === image , "Should bind a UIImage to the image property of UIImageView")
    }
}
