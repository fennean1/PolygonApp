//
//  Nodes.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 8/13/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit

// On No! The location states need to be reset or..managed...or something.
enum LocationState
{
    case above
    case below
    case inactive
    case onborder
}


class Node {
    // Location of the node
    var location: CGPoint!
    
    // This will change all the time for every cut pretty much. I don't like it. Sort of just using it to test an idea.
    var insertedAfter: Int = 0
    
    // Origin of coordinate system in which the node is drawn.
    var origin = CGPoint(x: 0, y: 0)
    
    var locationInSuperview: CGPoint {
        return addPoints(a: self.location, b: self.origin)
    }
    
    // Node that must be matched with this one to put the puzzle together.
    var sister: Int?
    
    // Determines if the node is a top node or bottom node. Either above or below.
    // node might not have a LocationState if it's not part of a cutting process.
    var locationState: LocationState?
     
    init(_location: CGPoint,_sister: Int?){
        self.location = _location
        self.sister = _sister
    }
    
}
