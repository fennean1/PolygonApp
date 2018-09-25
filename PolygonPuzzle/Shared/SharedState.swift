//
//  SharedState.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 9/17/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit

struct MyPuzzles {
    
    var puzzles: [PuzzleStruct] = []
    
    // Cool, Structs can take an init - probably don't need this right now.
    init(n: Int) {
        print("Balls")
    }
    
}

struct SessionStruct {
    var puzzles: [PuzzleStruct] = []
    var savePieces: [Polygon] = []
}


struct PuzzleStruct {
    var pieces: [Polygon] = []
    var originalPolygon: Int!
    init(originalPolygon: Int,pieces: [Polygon]){
        self.pieces = pieces
        self.originalPolygon = originalPolygon
    }
}


var SavedPolygons: [DraggablePolygon] = []
var ActiveSavedPolygonIndex = 0
var ActiveSavedPolygon: DraggablePolygon {
    return SavedPolygons[ActiveSavedPolygonIndex]
}


var AllPolygons: [DraggablePolygon] = []
var ActivePolygonIndex = 0

// I think that active polygon shouldn't be a computed value.
var ActivePolygon: DraggablePolygon {
    return AllPolygons[ActivePolygonIndex]
}
