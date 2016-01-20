//
//  CollectionChangeset.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/20/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public struct CollectionChangeset {

    public private(set) lazy var collectionOperations = Set<ListOperation>()
    public private(set) lazy var sectionsOperations = [Int: Set<ListOperation>]()
}
