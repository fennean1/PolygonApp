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
var Cutting = false // Will be deprecated for FirstCut and SecondCut
var FirstStrokeHasBeenMade = false
var SecondStrokeHasBeenMade = false
var AllPolygons: [DraggablePolygon] = []
var LinesToCut: [Line] = []
var LineToCutWith: Line! // Deprecating for First and Second Line
var FirstLineToCutWith: Line!
var SecondLineToCutWith: Line!
var VertexOfTheCut: Node? // Coordinate system????
var FirstCutPoint: Node?
var SecondCutPoint: Node?
// Really should be called "CutNodes" because these are the nodes that are used to cut the view
// Also, they may or may not intersect with the figure. 
var IntersectionNodes: [Node] = []
var ActivePolygonIndex = 0
var OriginalLocations: [CGPoint] = []

var ActivePolygon: DraggablePolygon {
    return AllPolygons[ActivePolygonIndex]
}
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

// Re-Animates to original locations.
func returnPolygonsToView(){
    UIView.animate(withDuration: 1, animations: {
        for (i,p) in AllPolygons.enumerated() {
            if p != ActivePolygon {
               p.frame.origin = OriginalLocations[i]
            }
        }})
}

// Applies an outer glow to the active polygon.
func applyShadows() {
    for p in AllPolygons {
        if p != ActivePolygon{
            p.layer.shadowOpacity = 0
        }
    }
}

// HOW DO THESE POLYGONS KNOW THEIR FRAME? NEEDS TO BE COMPUTED FROM NODES.
func redrawPolygons(){
    for p in AllPolygons {
        p.drawTheLayer()
    }
}



