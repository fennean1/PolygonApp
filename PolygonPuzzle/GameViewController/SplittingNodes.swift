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
func splitNodesWithSingleCut(nodes: [Node])-> ([Node],[Node]) {
    
    // For a straight line, we let the vertex equal the mid point.
    let dummyVertex = midPoint(a: (StartOfCut?.location)!, b: (EndOfCut?.location)!)
    
    var vertexNode: Node!
    
    var nodesWithState: [Node] = []
 
    vertexNode = Node(_location: dummyVertex, _sister: SisterIndex)
    
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

