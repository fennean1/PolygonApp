//
//  DrawPolygons.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 8/14/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit

// HOW DO THESE POLYGONS KNOW THEIR FRAME? NEEDS TO BE COMPUTED FROM NODES.
func redrawPolygons(){
    
     let origins = AllPolygonOrigins
    
    for p in AllPolygons {
        p.drawTheLayer()
    }    
}
