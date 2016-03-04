//
//  Observable.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/4/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol Observable {
    typealias ObservationValue
    
    func addObserver(observer: ObservationValue -> Void) -> Disposable
    func sendNext(value: ObservationValue)
}
