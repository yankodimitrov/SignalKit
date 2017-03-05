//
//  UIImageViewExtensionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UIImageViewExtensionsTests: XCTestCase {
    
    var bag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        bag = DisposableBag()
    }
    
    func testBindToImage() {
        
        let signal = Signal<UIImage?>()
        let imageView = UIImageView()
        let image = UIImage()
        
        imageView.image = nil
        
        signal.bindTo(imageIn: imageView).disposeWith(bag)
        
        signal.send(image)
        
        XCTAssert(imageView.image === image, "Should bind the UIImage to the image property of UIImageView")
    }
}
