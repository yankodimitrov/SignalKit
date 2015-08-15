//
//  SignalEventType.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/15/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation
import UIKit

public protocol SignalEventType {
    typealias Sender
    
    var sender: Sender {get}
}
