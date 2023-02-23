//
//  FiltersGestureEngine.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 8/7/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

public protocol FiltersGestureDelegate: AnyObject {
    /// Called everytime the gesture detect a new change in the gesture
    func didSwipeToChangeFilter(withNewIndex newIndex: Int)
}

public class FiltersGestureEngine {
    private let previewView: UIView!
    public weak var delegate: FiltersGestureDelegate?
    public var filterIndex = 0
    public let leftSwipeGesture: UISwipeGestureRecognizer = {
        let gest = UISwipeGestureRecognizer()
        gest.direction = .left
        return gest
    }()
    public let rightSwipeGesture: UISwipeGestureRecognizer = {
        let gest = UISwipeGestureRecognizer()
        gest.direction = .right
        return gest
    }()
    
    public var collectionCount = FilterCollection.aCollection.filters.count + 1 {
        didSet {
            filterIndex = 1
        }
    }
    
    public init(previewView: UIView) {
        self.previewView = previewView
        attachGesture()
    }
    
    // MARK: - Class methods
    /// Attach the gesture to the view to enable gesture listening
    private func attachGesture() {
        leftSwipeGesture.addTarget(self, action: #selector(changeFilterSwipe))
        previewView.addGestureRecognizer(leftSwipeGesture)
        
        rightSwipeGesture.addTarget(self, action: #selector(changeFilterSwipe))
        previewView.addGestureRecognizer(rightSwipeGesture)
    }
    
    @objc private func changeFilterSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            filterIndex = (filterIndex + 1) % collectionCount
        } else if gesture.direction == .right {
            filterIndex = (filterIndex + collectionCount - 1) % collectionCount
        }
        
        delegate?.didSwipeToChangeFilter(withNewIndex: filterIndex)
    }
}
