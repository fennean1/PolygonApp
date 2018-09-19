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

let markerOne = UIImageView(image: Marker)
let markerTwo = UIImageView(image: Marker)
let markerThree = UIImageView(image: Marker)

var cutOrCancelButton: UIButton!
var undoButton: UIButton!

var LinesToCut: [Line] = []
var LineToCutWith: Line!


// State Variables.
var ValidCutHasBeenMade = false {
    didSet {
        if ValidCutHasBeenMade {
            cutOrCancelButton.setImage(DoneImage, for: .normal)
        }
        else {
            cutOrCancelButton.setImage(CancelImage, for: .normal)
        }
    }
}

var CuttingViewNeedsClearing = false

var ActivelyCutting = false {
    didSet {
        if ActivelyCutting {
            cutOrCancelButton.setImage(CancelImage, for: .normal)
        }
        else {
            cutOrCancelButton.setImage(Scissors, for: .normal)
        }
    }
}

// To do multiple zigs we need to stored the vertices as an array.
//var ZigVertices: [Node] = []

var StartOfCut: Node?
var VertexOfTheCut: Node?
var EndOfCut: Node?


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



