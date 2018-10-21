//
//  Styles.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 7/23/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

// Determines what fraction we take in order to create the dimensions of action buttons
let compressionFactor: CGFloat = 10

import Foundation
import UIKit

extension CGRect {
    
    
    mutating func styleOptionButton(order: Int, container: CGRect) {
        
        let h = container.height/7
        let w = 0.8*container.width
        let y = CGFloat(order)*h
        let x = container.width/2 - w/2
        
        self = CGRect(x: x, y: y, width: w, height: h)
        
    }
    
    
    
    mutating func styleTopRight(container: CGRect) {
        
        let dims = [container.width,container.height]
        let h = dims.min()!/compressionFactor
        let w = h
    
        let x: CGFloat = container.width - 1.5*w
        let y: CGFloat = 0.5*h
    
        self = CGRect(x: x, y: y, width: w, height: h)
    
    }
    
    mutating func styleTopLeft(container: CGRect) {
        
        let dims = [container.width,container.height]
        let h = dims.min()!/compressionFactor
        let w = h
        
        let x: CGFloat = 0.5*w
        let y: CGFloat = 0.5*h
        
        self = CGRect(x: x, y: y, width: w, height: h)
        
    }
    
    mutating func styleHideTopMiddle(container: CGRect) {
        
        let dims = [container.width,container.height]
        let h = dims.min()!/7
        let w = h
        
        let x: CGFloat = 0.5*dims.min()! - 0.5*w
        let y: CGFloat = -2*w
        
        self = CGRect(x: x, y: y, width: w, height: h)
        
    }
    
    mutating func styleTopMiddle(container: CGRect) {
        
        let dims = [container.width,container.height]
        let h = dims.min()!/compressionFactor
        let w = h
        
        let x: CGFloat = 0.5*dims.min()! - 0.5*w
        let y: CGFloat = 0.5*w
        
        self = CGRect(x: x, y: y, width: w, height: h)
        
    }
    
    mutating func styleBottomMiddle(container: CGRect) {
        
        let dims = [container.width,container.height]
        let h = dims.min()!/compressionFactor
        let w = h
        
        let x: CGFloat = 0.5*dims.min()! - 0.5*w 
        let y: CGFloat = container.height - 1.5*w
        
        self = CGRect(x: x, y: y, width: w, height: h)
    }

    mutating func styleHideBottomMiddle(container: CGRect) {
        
        let dims = [container.width,container.height]
        let h = dims.min()!/7
        let w = h
        
        let x: CGFloat = container.width/2 - w/2
        let y: CGFloat = container.height + 1.5*w
        
        self = CGRect(x: x, y: y, width: w, height: h)
        
    }
    
    mutating func styleBottomLeft(container: CGRect) {
        
        let dims = [container.width,container.height]
        let h = dims.min()!/compressionFactor
        let w = h
        
        let x: CGFloat = 0.5*w
        let y: CGFloat = container.height - 1.5*w
        
        self = CGRect(x: x, y: y, width: w, height: h)
        
    }
    
    mutating func styleBottomRight(container: CGRect) {
        
        let dims = [container.width,container.height]
        let h = dims.min()!/compressionFactor
        let w = h
        
        let x: CGFloat = container.width - 1.5*w
        let y: CGFloat = container.height - 1.5*w
        
        self = CGRect(x: x, y: y, width: w, height: h)
        
    }
    
    mutating func styleInitialPolygonFrame(container: CGRect) {
        
        // Polygon is 80% of the frame width. (What about landscape mode?)
        let polygonWidth = 0.8*container.width
        let polygonHeight = polygonWidth
        
        let x = 0.10*container.width
        let y =  0.5*(container.height-polygonHeight)
        let w = polygonWidth
        let h = polygonHeight

        self = CGRect(x: x, y: y, width: w, height: h)        
    }
    
    mutating func styleUnderTopRight(container: CGRect) {
        
        let dims = [container.width,container.height]
        let h = dims.min()!/compressionFactor
        let w = h

        let x: CGFloat = container.width - 1.5*w
        let y: CGFloat = 1.5*h
        
        self = CGRect(x: x, y: y, width: w, height: h)
        
    }

    mutating func styleFillContainer(container: CGRect) {
    
        let x: CGFloat = 0
        let y: CGFloat = 0
    
        let w = container.width
        let h = container.height
    
        self = CGRect(x: x, y: y, width: w, height: h)
    
    }
    
    mutating func styleHideObject(size: CGSize) {
        
        let x = -size.width
        let y = -size.height
        
        let w = size.width
        let h = size.height
        
        self = CGRect(x: x, y: y, width: w, height: h)
        
    }
    
    mutating func styleHideMarker(container: CGRect) {
        
        let x: CGFloat = -container.width/10
        let y: CGFloat = -container.width/10
        
        let w = container.width/25
        let h = container.width/25
        
        self = CGRect(x: x, y: y, width: w, height: h)
        
    }

}
