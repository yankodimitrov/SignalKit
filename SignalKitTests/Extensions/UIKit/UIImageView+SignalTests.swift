//
//  UIImageView+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UIImageView_SignalTests: XCTestCase {
    
    var imageView: UIImageView!
    var signalsBag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        imageView = UIImageView()
        signalsBag = DisposableBag()
    }
    
    func testBindToImageInImageView() {
        
        let image = UIImage()
        let signal = MockSignal<UIImage?>()
        
        signal.bindTo(imageIn: imageView).disposeWith(signalsBag)
        
        signal.dispatch(image)
        
        XCTAssert(imageView.image! === image , "Should bind a UIImage to the image property of UIImageView")
    }
}
