//
//  Nodes.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 8/13/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit

// Currently assuming that sisters and nodes are seperate
func splitNodes(cutNodes: [Node],nodes: [Node])-> ([Node],[Node]){

    let cutter = Line(_firstPoint: cutNodes[0].location, _secondPoint: cutNodes[1].location)
    
    // Used for assigning location states
    for n in nodes {
        // Number of bottom arrays and number of top arrays.
        if n.location.y > cutter.y(x: n.location.x){
            n.locationState = LocationState.above
        } else {
            n.locationState = LocationState.below
        }
        
    }
    
    // IDEA: Map Filter to find the thing something like $1 = $0 + 1
    
    print("This is the location state of the first node",nodes[0].locationState!)
    
    // indices at which we need to break our function
    var breakAtIndices: [Int] = []
    
    var nodesWithCutPointsInserted: [Node] = []
    
    let nodeCount = nodes.count
    
    
    for (i,n) in nodes.enumerated(){
        
        // So that "next node" doesn't fall out of index range.
        let nextIndex = (i+1) % nodeCount
        
        // Check for when the location state changes
        let currentNode = n
        let nextNode = nodes[nextIndex]
        
        nodesWithCutPointsInserted.append(currentNode)
        let nodeCount = nodesWithCutPointsInserted.count
        
        if currentNode.locationState != nextNode.locationState {
            // Construct a line between the nodes...fuck - what coordinate system is this in?
            let connectingLine = Line(_firstPoint: currentNode.location, _secondPoint: nextNode.location)
            
            let intersectsAtFirstCutNode = connectingLine.containsPoint(point: cutNodes[0].location)
            let intersectsAtSecondCutNode = connectingLine.containsPoint(point: cutNodes[1].location)
            
            if intersectsAtFirstCutNode {
                breakAtIndices.append(nodeCount)
                nodesWithCutPointsInserted.append(cutNodes[0])
            }
            
            if intersectsAtSecondCutNode {
                breakAtIndices.append(nodeCount)
                nodesWithCutPointsInserted.append(cutNodes[1])
            }
        }
    }
    
    // It's possible that these don't exist (sort of)
    let firstIndexToBreakAt = breakAtIndices[0]
    let secondIndexToBreakAt = breakAtIndices[1]
    
    let firstNodesToDraw = Array(nodesWithCutPointsInserted[...firstIndexToBreakAt] + nodesWithCutPointsInserted[secondIndexToBreakAt...])
    let secondNodesToDraw = Array(nodesWithCutPointsInserted[firstIndexToBreakAt...secondIndexToBreakAt])
    
    return (firstNodesToDraw,secondNodesToDraw)
    
}


// On No! The location states need to be reset or..managed...or something.

enum LocationState
{
    case above
    case below
    case inactive
}

class Node {
    // Location of the node
    var location: CGPoint!
    
    // Node that must be matched with this one to put the puzzle together.
    var sister: Int?
    
    // Determines if the node is a top node or bottom node. Either above or below.
    // node might not have a LocationState if it's not part of a cutting process.
    var locationState: LocationState?
    
    // Next node in linked list
    var next: Node?
    
    // Weak due to "ownership cycle". Might want to read more about this.
    weak var previous: Node?
    
    init(_location: CGPoint,_sister: Int?){
        self.location = _location
        self.sister = _sister
    }
    
}
