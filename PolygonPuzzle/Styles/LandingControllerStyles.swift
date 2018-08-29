//
//  Styles.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 7/23/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {


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
