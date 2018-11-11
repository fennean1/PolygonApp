//
//  Styles.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 10/28/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit


extension CGRect {

    mutating func styleColorPickerButton(order: CGFloat, container: CGRect) {
        
        let h = container.width/10
        let w = h
        let y = container.height - 1.2*h
        let x = order*h
        
        self = CGRect(x: x, y: y, width: w, height: h)
    }
}

