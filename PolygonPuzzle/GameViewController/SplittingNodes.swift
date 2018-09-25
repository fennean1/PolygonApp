//
//  SplittingNodes.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 8/31/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit

// Is any vertex by default going to be a new sister?


// This takes car of assigning sisters when a node interesects on the border.
func assignNodeStatesBasedOnVertex(nodes: [Node],vertex: Node,cutPoints: [Node]) -> [Node] {
    
    var topSister: Int?
    var bottomSister: Int?
    
    let firstCutPoint = cutPoints[0]
    let secondCutPoint = cutPoints[1]
    
    // Create the vectors
    let cutVectorOne = vector(start: vertex.location, end: firstCutPoint.location)
    let cutVectorTwo = vector(start: vertex.location, end: secondCutPoint.location)
    
    // Find the angles formed by each
    let angleOne = cutVectorOne.theta
    let angleTwo = cutVectorTwo.theta
    
    // find the max and min
    let topAngle = [angleOne,angleTwo].max()
    let bottomAngle = [angleOne,angleTwo].min()
    
    // Risky equality?
    if topAngle == angleOne {
        print("top angle = angle one")
        topSister = firstCutPoint.sister
    }
    
    if topAngle == angleTwo {
        print("top angle = angle two")
        topSister = secondCutPoint.sister
    }
    
    if bottomAngle == angleOne {
        print("bottom angle = angle one")
        bottomSister = firstCutPoint.sister
    }
    
    if bottomAngle == angleTwo {
        print("bottom angle = angle two")
        bottomSister = secondCutPoint.sister
    }
    
    
    for n in nodes {
        
        let v = vector(start: vertex.location, end: n.location!)
        
        if v.theta < topAngle! && v.theta > bottomAngle! {
            
            n.locationState = LocationState.below
        }
        else if abs(v.theta - topAngle!) < 0.0001 {
            
            print("Assigning a sister that's on the border")
            n.locationState = LocationState.onborder

            
        } else if abs(v.theta - bottomAngle!) < 0.0001 {
            
            print("assigning a sister that's on the border")
            n.locationState = LocationState.onborder

        }
        else {
            n.locationState = LocationState.above
        }
    }
    
    return nodes
}



// Takes an array of nodes that represent a figure as well as the nodes that it needs to be split at.
func splitNodesWithSingleCut(nodes: [Node])-> ([Node],[Node]) {
    
    // For a straight line, we let the vertex equal the mid point.
    let dummyVertex = midPoint(a: (StartOfCut?.location)!, b: (EndOfCut?.location)!)
    
    // WHAAAAAT? SET HERE? (start and end of cut)
    StartOfCut?.sister = SisterIndex
    EndOfCut?.sister = SisterIndex+1
    SisterIndex += 2
    
    var vertexNode: Node!
    
    var nodesWithState: [Node] = []
 
    // Create node from the dummy vertex point.
    vertexNode = Node(_location: dummyVertex, _sister: nil)
    
    // AND THEN PASSED HERE? (start and end of cut)
    nodesWithState = assignNodeStatesBasedOnVertex(nodes: nodes, vertex: vertexNode, cutPoints: [StartOfCut!,EndOfCut!])
    
    // indices at which we need to break our nodesWithCutPointsInserted Array
    var breakAtIndices: [Int] = []
    
    var nodesWithCutPointsInserted: [Node] = []
    
    let nodeCount = nodes.count
    
    for (i,n) in nodesWithState.enumerated(){
        
        // So that "next node" doesn't fall out of index range.
        let nextIndex = (i+1) % nodeCount
        
        // Check for when the location state changes
        let currentNode = n
        let nextNode = nodesWithState[nextIndex]
        
        nodesWithCutPointsInserted.append(currentNode)
        let nodeCount = nodesWithCutPointsInserted.count
        
        if currentNode.locationState == LocationState.onborder {
            breakAtIndices.append(nodeCount-1)
        }
        else if nextNode.locationState == LocationState.onborder {
            // Do nothing right now. If the next node is on the border it will
            // be added in the next iteration.
        }
        else if currentNode.locationState != nextNode.locationState {
            
            // Construct a line between the nodes.
            let connectingLine = Line(_firstPoint: currentNode.location, _secondPoint: nextNode.location)
            
            let intersectsAtFirstCutNode = connectingLine.containsPoint(point: (StartOfCut?.location)!)

            let intersectsAtSecondCutNode = connectingLine.containsPoint(point: (EndOfCut?.location)!)

            
            if intersectsAtFirstCutNode {
                breakAtIndices.append(nodeCount)
                nodesWithCutPointsInserted.append(StartOfCut!)
            }
            
            if intersectsAtSecondCutNode {
                breakAtIndices.append(nodeCount)
                nodesWithCutPointsInserted.append(EndOfCut!)
            }
        }
    }
    
    // HELLO Need a safegaurd here so it doesn't toally crash
    
    
    let firstIndexToBreakAt = breakAtIndices[0]
    let secondIndexToBreakAt = breakAtIndices[1]
    
    let firstNodesToDraw = Array(nodesWithCutPointsInserted[...firstIndexToBreakAt] + nodesWithCutPointsInserted[secondIndexToBreakAt...])
    let secondNodesToDraw = Array(nodesWithCutPointsInserted[firstIndexToBreakAt...secondIndexToBreakAt])
    
    return (firstNodesToDraw,secondNodesToDraw)
    
}


// Takes an array of nodes that represent a figure as well as the nodes that it needs to be split at.
func splitNodesWithDualCut(nodes: [Node])-> ([Node],[Node]){

    var nodesWithState: [Node] = []
    
    StartOfCut?.sister = SisterIndex
    VertexOfTheCut?.sister = SisterIndex+1
    EndOfCut?.sister = SisterIndex+2
    SisterIndex += 3

    // This will decrement the sister index if one of the cuts absorbs the index of an existing nodes.
    nodesWithState = assignNodeStatesBasedOnVertex(nodes: nodes, vertex: VertexOfTheCut!, cutPoints: [StartOfCut!,EndOfCut!])
    
    // indices at which we need to break our nodesWithCutPointsInserted Array
    var breakAtIndices: [Int] = []
    
    var nodesWithCutPointsInserted: [Node] = []
    
    let totalNodeCount = nodes.count
    
    for (i,n) in nodesWithState.enumerated(){
        
        // So that "next node" doesn't fall out of index range.
        let nextIndex = (i+1) % totalNodeCount
        
        // Check for when the location state changes
        let currentNode = n
        let nextNode = nodesWithState[nextIndex]
        
        // Construct a line between the nodes.
        let connectingLine = Line(_firstPoint: currentNode.location, _secondPoint: nextNode.location)
        
        let intersectsAtFirstCutNode = connectingLine.containsPoint(point: (StartOfCut?.location)!)
 
        let intersectsAtSecondCutNode = connectingLine.containsPoint(point: (EndOfCut?.location)!)
 
        let intersectsAtBothNodes = intersectsAtFirstCutNode && intersectsAtSecondCutNode

        nodesWithCutPointsInserted.append(currentNode)
        let nodeCount = nodesWithCutPointsInserted.count
  
        if intersectsAtBothNodes {
    
            let distanceOfFirst = distance(a: (StartOfCut?.location)!, b: currentNode.location)
            let distanceOfSecond = distance(a: (EndOfCut?.location)!, b: currentNode.location)
            
            if distanceOfFirst < distanceOfSecond {
                nodesWithCutPointsInserted.append(StartOfCut!)
                breakAtIndices.append(nodeCount)
                nodesWithCutPointsInserted.append(EndOfCut!)
                breakAtIndices.append(nodeCount+1)
            }
            else if distanceOfFirst > distanceOfSecond {
                nodesWithCutPointsInserted.append(EndOfCut!)
                breakAtIndices.append(nodeCount)
                nodesWithCutPointsInserted.append(StartOfCut!)
                breakAtIndices.append(nodeCount+1)
            }
        }
        else if currentNode.locationState == LocationState.onborder {

            breakAtIndices.append(nodeCount-1)
        }
        else if nextNode.locationState == LocationState.onborder{
            // try not doing anything
        }
        else if currentNode.locationState != nextNode.locationState {
 
            if intersectsAtFirstCutNode {
                breakAtIndices.append(nodeCount)
                nodesWithCutPointsInserted.append(StartOfCut!)
            }
            
            if intersectsAtSecondCutNode {
                breakAtIndices.append(nodeCount)
                nodesWithCutPointsInserted.append(EndOfCut!)
            }
        }
    }
    
    // HELLO Need a safegaurd here so it doesn't toally crash
    let firstIndexToBreakAt = breakAtIndices[0]
    let secondIndexToBreakAt = breakAtIndices[1]
    
    var firstNodesToDraw = Array(nodesWithCutPointsInserted[...firstIndexToBreakAt])
    firstNodesToDraw.append(VertexOfTheCut!)
    firstNodesToDraw = Array(firstNodesToDraw + nodesWithCutPointsInserted[secondIndexToBreakAt...])
    
    var secondNodesToDraw = Array(nodesWithCutPointsInserted[firstIndexToBreakAt...secondIndexToBreakAt])
    secondNodesToDraw.append(VertexOfTheCut!)
    
    // I don't want to need this but right now I do.
    let firstNodesToDrawDeduped = removeDuplicateNodes(nodes: firstNodesToDraw)
    let secondNodesToDrawDeduped = removeDuplicateNodes(nodes: secondNodesToDraw)
    
    return (firstNodesToDrawDeduped,secondNodesToDrawDeduped)
    
}

