//
//  PreloadedPuzzles.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 10/15/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit


func loadRawPuzzlesToCoreData() {
    
    print("LOADING RAW PUZZLLLLLESSS!")
    for (i,rP) in RawPuzzles.enumerated() {
        let polys = buildPolygonsFromRawPuzzle(rawPuzzle: rP.0, _scale: InitialPolygonDim,origins: rP.1)
        savePuzzleToCoreData(polygons: polys, name: "First Puzzle",dim: InitialPolygonDim)
    }
}

func printRandCoordinatesActivePolygonFrame(number: Int) {
    
    var yesOrNo = "yes"
    
    let flexableOriginX = ActivePolygon.frame.origin.x*0.8
    let flexableOriginY = ActivePolygon.frame.origin.y*0.8
    
    let w = ActivePolygon.frame.width*1.2
    let h = ActivePolygon.frame.height*1.2
    

    print("[")
    for n in 0...number {
    

    let rX = CGFloat(arc4random_uniform(UInt32(w)))

    let rY = CGFloat(arc4random_uniform(UInt32(h)))

    let x = rX + flexableOriginX
    let y = rY + flexableOriginY
        
    let pointInsideActivePolygonCoordinateSystem = subtractPoints(a: CGPoint(x: x, y: y), b: ActivePolygon.frame.origin)
    
    let contains = ActivePolygon.layer.contains(pointInsideActivePolygonCoordinateSystem)
    
    if contains {
        yesOrNo = "true"
    } else {
        yesOrNo = "false"
    }
        print("{\(n):","{x:\(x),y:\(y),in: \(yesOrNo)}},")
}
    print("]")
}



func printRawJSONPuzzle() {
    
    /*
    {
        <locationId>: {
            latitude: 38.899897,
            longitude: -77.026484
        }
    }
    */
    
    let activePolygonOrigin = ActivePolygon.frame.origin
    
        print("[")
        for (i,n) in ActivePolygon.nodes!.enumerated() {
            let pointInSuperView = addPoints(a: activePolygonOrigin, b: n.location)
            print("{longitude:",pointInSuperView.x,",latitude:",pointInSuperView.y,"},")
        }
        print("]")

}

func printRawPuzzle(polygons: [DraggablePolygon]) {
    for p in polygons {
        print("[")
        for (i,n) in p.nodes!.enumerated() {
            print("(",n.location.x/InitialPolygonDim,",",n.location.y/InitialPolygonDim,",",i,"),")
        }
        print("],")
    }
    
    print("These are the origins")
    
    for p in polygons {
       print("[",p.originalOrigin.x/InitialPolygonDim,",",p.originalOrigin.y/InitialPolygonDim,"]")
    }
    
}

func buildPolygonsFromRawPuzzle(rawPuzzle: [[(CGFloat,CGFloat,Int)]], _scale: CGFloat,origins: [(CGFloat,CGFloat)])-> [DraggablePolygon] {
    
    var polygons: [DraggablePolygon] = []
    
    for (i,rawPolygons) in rawPuzzle.enumerated() {
    
        let scaledPoints = rawPolygons.map({scalePoint(by: _scale, point: CGPoint(x:$0.0,y: $0.1))})
        let newPolygon = DraggablePolygon()
        let rawOrigin = origins[i]
        let originalOriginAsCGPoint = CGPoint(x: CGFloat(InitialPolygonDim*rawOrigin.0), y: CGFloat(InitialPolygonDim*rawOrigin.1))
        print("originalOriginAsCGPoint",originalOriginAsCGPoint)
        newPolygon.frame = getFrame(of: scaledPoints)
        newPolygon.config(vertices: scaledPoints)
        newPolygon.originalOrigin = originalOriginAsCGPoint
        polygons.append(newPolygon)
        
    }
    
    return polygons
}


let RawPuzzles = [(rawCoordinatesPuzzleOne,rawOriginsPuzzleOne)]


