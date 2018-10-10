//
//  SharedState.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 9/17/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit

var FetchedPolygons: [DraggablePolygon]!

var SavedPolygons: [DraggablePolygon] = []
var ActiveSavedPolygonIndex = 0
var ActiveSavedPolygon: DraggablePolygon {
    return SavedPolygons[ActiveSavedPolygonIndex]
}

var AllPolygons: [DraggablePolygon] = []
var ActivePolygonIndex = 0

// I think that active polygon shouldn't be a computed value. This is causing problems 
var ActivePolygon: DraggablePolygon {
    return AllPolygons[ActivePolygonIndex]
}


 
