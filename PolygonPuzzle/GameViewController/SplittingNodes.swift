//
//  SplittingNodes.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 8/31/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit



// Takes an array of nodes that represent a figure as well as the nodes that it needs to be split at.
func splitNodesWithSingleCut(cutNodes: [Node],nodes: [Node])-> ([Node],[Node]){
    
    // For a straight line, we let the vertex equal the mid point.
    let dummyVertex = midPoint(a: cutNodes[0].location, b: cutNodes[1].location)
    
    var vertexNode: Node!
    
    var nodesWithState: [Node] = []
 
    vertexNode = Node(_location: dummyVertex, _sister: SisterIndex)
    
    nodesWithState = assignNodeStatesBasedOnVertex(nodes: nodes, vertex: vertexNode, cutPoints: [IntersectionNodes[0],IntersectionNodes[1]])
    
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
            print("Found a border node!")
            breakAtIndices.append(nodeCount-1)
        }
        else if nextNode.locationState == LocationState.onborder {
            // Do nothing right now. If the next node is on the border it will
            // be added in the next iteration.
        }
        else if currentNode.locationState != nextNode.locationState {
            
            // Construct a line between the nodes.
            let connectingLine = Line(_firstPoint: currentNode.location, _secondPoint: nextNode.location)
            
            let intersectsAtFirstCutNode = connectingLine.containsPoint(point: IntersectionNodes[0].location)
            print("Line intersects with the first cut node?", intersectsAtFirstCutNode)
            let intersectsAtSecondCutNode = connectingLine.containsPoint(point: IntersectionNodes[1].location)
            print("Line intersects with the second cut node?",intersectsAtSecondCutNode )
            
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
    
    // HELLO Need a safegaurd here so it doesn't toally crash
    let firstIndexToBreakAt = breakAtIndices[0]
    let secondIndexToBreakAt = breakAtIndices[1]
    
    let firstNodesToDraw = Array(nodesWithCutPointsInserted[...firstIndexToBreakAt] + nodesWithCutPointsInserted[secondIndexToBreakAt...])
    let secondNodesToDraw = Array(nodesWithCutPointsInserted[firstIndexToBreakAt...secondIndexToBreakAt])
    
    return (firstNodesToDraw,secondNodesToDraw)
    
}



// Takes an array of nodes that represent a figure as well as the nodes that it needs to be split at.
func splitNodesWithDualCut(cutNodes: [Node],nodes: [Node])-> ([Node],[Node]){

    
    var vertexNode: Node!
    
    var nodesWithState: [Node] = []
    
    // This is also stored at VertexOfCut but probably doesn't need to be.
    vertexNode = IntersectionNodes[1]
    
    nodesWithState = assignNodeStatesBasedOnVertex(nodes: nodes, vertex: vertexNode, cutPoints: [IntersectionNodes[0],IntersectionNodes[2]])
    
    
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
        
        let intersectsAtFirstCutNode = connectingLine.containsPoint(point: IntersectionNodes[0].location)
        print("Line intersects with the first cut node?", intersectsAtFirstCutNode)
        let intersectsAtSecondCutNode = connectingLine.containsPoint(point: IntersectionNodes[2].location)
        print("Line intersects with the second cut node?",intersectsAtSecondCutNode )
        let intersectsAtBothNodes = intersectsAtFirstCutNode && intersectsAtSecondCutNode

        nodesWithCutPointsInserted.append(currentNode)
        let nodeCount = nodesWithCutPointsInserted.count
  
        if intersectsAtBothNodes {
            print("OMG! It intersects at both cut nodes!!")
            
            let distanceOfFirst = distance(a: IntersectionNodes[0].location, b: currentNode.location)
            let distanceOfSecond = distance(a: IntersectionNodes[2].location, b: currentNode.location)
            
            if distanceOfFirst < distanceOfSecond {
                nodesWithCutPointsInserted.append(IntersectionNodes[0])
                breakAtIndices.append(nodeCount)
                nodesWithCutPointsInserted.append(IntersectionNodes[2])
                breakAtIndices.append(nodeCount+1)
            }
            else if distanceOfFirst > distanceOfSecond {
                nodesWithCutPointsInserted.append(IntersectionNodes[2])
                breakAtIndices.append(nodeCount)
                nodesWithCutPointsInserted.append(IntersectionNodes[0])
                breakAtIndices.append(nodeCount+1)
            }
        }
        else if currentNode.locationState == LocationState.onborder {
            print("Entered On the Border")
            breakAtIndices.append(nodeCount-1)
        }
        else if nextNode.locationState == LocationState.onborder{
            // try not doing anything
        }
        else if currentNode.locationState != nextNode.locationState {
            print("Entered current not equal to next")
            if intersectsAtFirstCutNode {
                breakAtIndices.append(nodeCount)
                nodesWithCutPointsInserted.append(IntersectionNodes[0])
            }
            
            if intersectsAtSecondCutNode {
                breakAtIndices.append(nodeCount)
                nodesWithCutPointsInserted.append(IntersectionNodes[2])
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

