//
//  UIImageViewFunctionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class UIImageViewFunctionsTests: XCTestCase {

    var imageView: UIImageView!
    var signalContainer: SignalContainer!
    
    override func setUp() {
        super.setUp()
        
        imageView = UIImageView()
        signalContainer = SignalContainer()
    }
    
    func testBindToImageIn() {
        
        let image = UIImage()
        let observableImage = ObservableOf<UIImage>()
        
        observe(observableImage)
            .bindTo(imageIn(imageView))
            .addTo(signalContainer)
        
        observableImage.dispatch(image)
        
        XCTAssert(imageView.image! === image, "Should bind UIImage to the image of UIImageView")
    }
}
