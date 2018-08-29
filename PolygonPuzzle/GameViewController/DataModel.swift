//
//  Data.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 7/23/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit

// Points are sisters if they share the same SisterIndex. Everytime we create new sisters, this index goes up so that the next pair of sisters get a new index.
var SisterIndex = 0
var Cutting = false
var AllPolygons: [DraggablePolygon] = []
var LinesToCut: [Line] = []
var LineToCutWith: Line!
var OtherLineToCutWith: Line!
var IntersectionNodes: [Node] = []
var ActivePolygonIndex = 0

var ActivePolygon: DraggablePolygon {
    return AllPolygons[ActivePolygonIndex]
}

var OriginalLocations: [CGPoint] = []

var AllPolygonOrigins: [CGPoint] {
    return AllPolygons.map({(p: DraggablePolygon)-> CGPoint in p.frame.origin}  )
}

func hideInactivePolygons(){
    
    OriginalLocations = AllPolygonOrigins
    
    UIView.animate(withDuration: 1, animations: {
        for p in AllPolygons {
            if p != ActivePolygon {
                let _size = p.frame.size
                p.frame.styleHideObject(size: _size)
            }
    }})
}


func returnPolygonsToView(){
    
    UIView.animate(withDuration: 1, animations: {
        for (i,p) in AllPolygons.enumerated() {
            if p != ActivePolygon {
               p.frame.origin = OriginalLocations[i]
            }
        }})
}

func applyShadows() {
    for p in AllPolygons {
        if p != ActivePolygon{
            p.layer.shadowOpacity = 0
        }
    }
}




