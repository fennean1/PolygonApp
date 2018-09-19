//
//  SharedState.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 9/17/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit





var SavedPolygons: [DraggablePolygon] = []
var ActiveSavedPolygonIndex = 0
var ActiveSavedPolygon: DraggablePolygon {
    return SavedPolygons[ActiveSavedPolygonIndex]
}


var AllPolygons: [DraggablePolygon] = []
var ActivePolygonIndex = 0
var ActivePolygon: DraggablePolygon {
    return AllPolygons[ActivePolygonIndex]
}
