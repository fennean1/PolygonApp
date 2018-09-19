//
//  DataModel.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 9/18/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit

struct UserStruct {
    var puzzles: [PuzzleStruct] = []
    var pieces: [Polygon] = []
}


struct PuzzleStruct {
    
    var user = ""
    var pieces: [Polygon] = []
    
    init(polygons: [Polygon],user: String) {
        self.pieces = polygons
    }
}


