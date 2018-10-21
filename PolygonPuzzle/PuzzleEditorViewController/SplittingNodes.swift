//
//  SplittingNodes.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 8/31/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit

// When the start of the cut is closer to the "nextNode" then our algorithm works so this is by default equal to true.
var flagStartCloserToNextNode = true

// This takes car of assigning sisters when a node interesects on the border.
func assignNodeStates(nodes: [Node],cutPoints: [Node]) -> [Node] {
    
    let nodeCount = nodes.count
    var firstSet = true
    
    // Let's let these always be the start and end - important right now.
    let cutPointOne = cutPoints[0]
    let cutPointTwo = cutPoints[1]
    
    for (i,n) in nodes.enumerated() {
        
        let thisNode = n
        let nextNodeIndex = (i+1)%nodeCount
        let nextNode = nodes[nextNodeIndex]
        
        let currentLine = Line(_firstPoint: thisNode.location, _secondPoint: nextNode.location)
        let containsStartPoint = currentLine.containsPoint(point: cutPointOne.location)
        let containsEndPoint = currentLine.containsPoint(point: cutPointTwo.location)
        let containsBothPoints = containsStartPoint && containsEndPoint
        let startDistanceFromNextNode = distance(a: (StartOfCut?.location)!, b: nextNode.location!)
        let endDistanceFromNextNode = distance(a: (EndOfCut?.location)!, b: nextNode.location!)
        let startIsOnTheNextNode = startDistanceFromNextNode < 0.10
        let endIsOnTheNextNode = endDistanceFromNextNode < 0.10
        
        
        if containsBothPoints {
            print("Contains both points")
           
            // Set is going to switch when the bridge contains both points.
            firstSet = !firstSet
            if firstSet == true {
                print("assigning state to above")
                nextNode.locationState = LocationState.above
            } else if firstSet == false {
                print("assigning state to below")
                nextNode.locationState = LocationState.below
            }
            
            StartOfCut?.insertedAfter = i
            EndOfCut?.insertedAfter = i
            
            // Some of the points might get "reassigned to border state"
            if startIsOnTheNextNode {
                nextNode.locationState = LocationState.onborder
                nextNode.insertedAfter = i
            }
            
            if endIsOnTheNextNode {
                nextNode.locationState = LocationState.onborder
                nextNode.insertedAfter = i  
            }
            
            if startDistanceFromNextNode > endDistanceFromNextNode {
                flagStartCloserToNextNode = false
            } else {
                flagStartCloserToNextNode = true
            }

        } else if startIsOnTheNextNode {
            nextNode.locationState = LocationState.onborder
            nextNode.insertedAfter = i
        } else if endIsOnTheNextNode {
            nextNode.locationState = LocationState.onborder
            nextNode.insertedAfter = i
        } else {
        
        if containsStartPoint {
            print("intersects as first cut point")
            StartOfCut?.insertedAfter = i
            firstSet = !firstSet
        }
        
        if containsEndPoint {
            EndOfCut?.insertedAfter = i
            print("intersects at second cut point")
            firstSet = !firstSet
        }
        
        if firstSet == true {
            print("assigning state to above")
            nextNode.locationState = LocationState.above
        } else if firstSet == false {
            print("assigning state to below")
            nextNode.locationState = LocationState.below
        }

        }

    }
    
    for n in nodes {
        print("Location State Of New Assignments",n.locationState!)
    }
    
    print("insert Start After",StartOfCut?.insertedAfter)
    print("inset End After",EndOfCut?.insertedAfter)
    
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
    //nodesWithState = assignNodeStatesBasedOnVertex(nodes: nodes, vertex: vertexNode, cutPoints: [StartOfCut!,EndOfCut!])
    
    nodesWithState = assignNodeStates(nodes: nodes, cutPoints: [StartOfCut!,EndOfCut!])

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

    
    VertexOfTheCut = VerticesOfCut.first
    
    var nodesWithState: [Node] = []
    
    var verticesForFirstPoints: [Node] = []
    var verticesForSecondPoints: [Node] = []
    
    StartOfCut?.sister = SisterIndex
    VertexOfTheCut?.sister = SisterIndex+1
    EndOfCut?.sister = SisterIndex+2
    SisterIndex += 3
    
    verticesForFirstPoints = VerticesOfCut.reversed()
    verticesForSecondPoints = VerticesOfCut
    
    nodesWithState = assignNodeStates(nodes: nodes, cutPoints: [StartOfCut!,EndOfCut!])
    
    if (StartOfCut?.insertedAfter)! > (EndOfCut?.insertedAfter)! {
        verticesForFirstPoints = VerticesOfCut.reversed()
        verticesForSecondPoints = VerticesOfCut
    } else if (StartOfCut?.insertedAfter)! < (EndOfCut?.insertedAfter)! {
        verticesForFirstPoints = VerticesOfCut
        verticesForSecondPoints = VerticesOfCut.reversed()
    } else if (StartOfCut?.insertedAfter)! == (EndOfCut?.insertedAfter)! {
        if !flagStartCloserToNextNode {
          verticesForFirstPoints = VerticesOfCut
          verticesForSecondPoints = VerticesOfCut.reversed()
        }
    }
    
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
                print("firstIndexToBreakAt:",nodeCount)
                nodesWithCutPointsInserted.append(StartOfCut!)
            }
            
            if intersectsAtSecondCutNode {
                breakAtIndices.append(nodeCount)
                print("Second index to break at",nodeCount)
                nodesWithCutPointsInserted.append(EndOfCut!)
            }
        }
    }
    
    print("indices to break",breakAtIndices)
    
    // HELLO Need a safegaurd here so it doesn't toally crash
    let firstIndexToBreakAt = breakAtIndices[0]
    let secondIndexToBreakAt = breakAtIndices[1]
    
    var firstNodesToDraw = Array(nodesWithCutPointsInserted[...firstIndexToBreakAt])
    firstNodesToDraw = firstNodesToDraw + verticesForFirstPoints
    firstNodesToDraw = Array(firstNodesToDraw + nodesWithCutPointsInserted[secondIndexToBreakAt...])

    var secondNodesToDraw = Array(nodesWithCutPointsInserted[firstIndexToBreakAt...secondIndexToBreakAt])
    secondNodesToDraw = secondNodesToDraw + verticesForSecondPoints
    
    // I don't want to need this but right now I do.
    let firstNodesToDrawDeduped = removeDuplicateNodes(nodes: firstNodesToDraw)
    let secondNodesToDrawDeduped = removeDuplicateNodes(nodes: secondNodesToDraw)
    
    return (firstNodesToDrawDeduped,secondNodesToDrawDeduped)
    
}

