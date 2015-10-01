//
//  ArrayBindingObserver.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 9/30/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class ArrayBindingObserver<T>: Disposable {
    
    internal var bindingStrategy: ArrayBindingStrategyType?
    
    private let array: ObservableArray<ObservableArray<T>>
    private lazy var sectionObservers = [Disposable]()
    private var arrayObserver: Disposable?
    
    public init(array: ObservableArray<ObservableArray<T>>) {
        
        self.array = array
        
        observeForArrayEvent()
        setupSectionObservers()
    }
    
    public convenience init(array: ObservableArray<T>) {
        
        let sectionsArray = ObservableArray<ObservableArray<T>>([array])
        
        self.init(array: sectionsArray)
    }
    
    deinit {
        
        dispose()
    }
    
    private func observeForArrayEvent() {
        
        arrayObserver = array.addObserver { [weak self] event in
            
            self?.handleArrayEvent(event)
        }
    }
    
    private func setupSectionObservers() {
        
        for (sectionIndex, section) in array.enumerate() {
            
            let observer = section.addObserver { [weak self] event in
                
                self?.handleSectionEvent(event, section: sectionIndex)
            }
            
            sectionObservers.append(observer)
        }
    }
    
    private func disposeSectionObservers() {
        
        for observer in sectionObservers {
            observer.dispose()
        }
    }
    
    private func handleArrayEvent(event: ObservableArrayEvent) {
        
        switch event {
        
        case .Reset:
            bindingStrategy?.reloadAllSections()
            
        case .Insert(let indexes):
            bindingStrategy?.insertSections(NSIndexSet(withSet: indexes))
        
        case .Update(let indexes):
            bindingStrategy?.reloadSections(NSIndexSet(withSet: indexes))
        
        case .Remove(let indexes):
            bindingStrategy?.deleteSections(NSIndexSet(withSet: indexes))
        
        case .Batch(let insertedIndexes, let updatedIndexes, let removedIndexes):
            
            bindingStrategy?.performBatchUpdate { [weak self] in
            
                self?.bindingStrategy?.insertSections(NSIndexSet(withSet: insertedIndexes))
                self?.bindingStrategy?.reloadSections(NSIndexSet(withSet: updatedIndexes))
                self?.bindingStrategy?.deleteSections(NSIndexSet(withSet: removedIndexes))
            }
        }
        
        disposeSectionObservers()
        setupSectionObservers()
    }
    
    private func handleSectionEvent(event: ObservableArrayEvent, section: Int) {
        
        switch event {
        
        case .Reset:
            bindingStrategy?.reloadRowsInSections(NSIndexSet(index: section))
        
        case .Insert(let indexes):
            bindingStrategy?.insertRowsAtIndexPaths(indexPathsForIndexes(indexes, inSection: section))
        
        case .Update(let indexes):
            bindingStrategy?.reloadRowsAtIndexPaths(indexPathsForIndexes(indexes, inSection: section))
        
        case .Remove(let indexes):
            bindingStrategy?.deleteRowsAtIndexPaths(indexPathsForIndexes(indexes, inSection: section))
        
        case .Batch(let insertedIndexes, let updatedIndexes, let removedIndexes):
            
            let insertedPaths = indexPathsForIndexes(insertedIndexes, inSection: section)
            let updatedPaths = indexPathsForIndexes(updatedIndexes, inSection: section)
            let removedPaths = indexPathsForIndexes(removedIndexes, inSection: section)
            
            bindingStrategy?.performBatchUpdate { [weak self] in
                
                self?.bindingStrategy?.insertRowsAtIndexPaths(insertedPaths)
                self?.bindingStrategy?.reloadRowsAtIndexPaths(updatedPaths)
                self?.bindingStrategy?.deleteRowsAtIndexPaths(removedPaths)
            }
        }
    }
    
    private func indexPathsForIndexes(indexes: Set<Int>, inSection section: Int) -> [NSIndexPath] {
        
        return indexes.map { NSIndexPath(forItem: $0, inSection: section) }
    }
    
    public func dispose() {
        
        arrayObserver?.dispose()
        disposeSectionObservers()
        
        arrayObserver = nil
        sectionObservers.removeAll()
    }
}
