//
//  Depracated.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 10/3/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit


// Deprecated
func assignNodeStatesBasedOnVertex(nodes: [Node],vertex: Node,cutPoints: [Node]) -> [Node] {
    
    
    var firstCutPoint = cutPoints[0]
    var secondCutPoint = cutPoints[1]
    
    // Create the vectors
    let cutVectorOne = vector(start: vertex.location, end: firstCutPoint.location)
    let cutVectorTwo = vector(start: vertex.location, end: secondCutPoint.location)
    
    
    // Find the angles formed by each
    let angleOne = cutVectorOne.theta
    let angleTwo = cutVectorTwo.theta
    
    print("first angle",angleOne)
    print("second angle",angleTwo)
    
    
    // find the max and min
    let topAngle = [angleOne,angleTwo].max()
    let bottomAngle = [angleOne,angleTwo].min()
    
    
    
    for n in nodes {
        
        let v = vector(start: vertex.location, end: n.location!)
        
        if v.theta < topAngle! && v.theta > bottomAngle! {
            
            n.locationState = LocationState.below
        }
        else if abs(v.theta - topAngle!) < 0.0001 {
            
            
            n.locationState = LocationState.onborder
            
            
        } else if abs(v.theta - bottomAngle!) < 0.0001 {
            
            n.locationState = LocationState.onborder
            
        }
        else {
            n.locationState = LocationState.above
        }
    }
    
    for n in nodes  {
        print("location state",n.locationState)
    }
    
    return nodes
}
