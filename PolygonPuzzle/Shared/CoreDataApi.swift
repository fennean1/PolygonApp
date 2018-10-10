//
//  Api.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 10/1/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit
import CoreData

func savePuzzleToCoreData(polygons: [DraggablePolygon], name: String) {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext

    let puzzleFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Puzzle")
    
    
    
    // Delete everything before starting over
    if let result = try? context.fetch(puzzleFetchRequest) {
        for object in result {
            context.delete(object as! NSManagedObject)
        }
    }
    
    
    print("creating puzzle entity")
    let puzzleEntity = NSEntityDescription.entity(forEntityName: "Puzzle", in: context)
    print("creating newPuzzle")
    let newPuzzle = NSManagedObject(entity: puzzleEntity!, insertInto: context) as! Puzzle
    print("setting value for new puzzle")
    newPuzzle.setValue(name, forKey: "name")
    
    
    for p in polygons {
        
        let polygonEntity = NSEntityDescription.entity(forEntityName: "Polygon", in: context)
        let newPolygon = NSManagedObject(entity: polygonEntity!, insertInto: context) as! Polygon
        newPolygon.setValue(p.originalOrigin.x, forKey: "originalX")
        newPolygon.setValue(p.originalOrigin.y, forKey: "originalY")
        
        newPuzzle.addToPolygons(newPolygon)
        
        for (i,n) in p.nodes!.enumerated() {
            
            let ex = Float(n.location.x)
            let why = Float(n.location.y)
            
            
            let nodeEntity = NSEntityDescription.entity(forEntityName: "PrimitiveNode", in: context)
            let newNode = NSManagedObject(entity: nodeEntity!, insertInto: context) as! PrimitiveNode
            newNode.setValue(ex, forKey: "xCoordinate")
            newNode.setValue(why, forKey: "yCoordinate")
            newNode.setValue(i, forKey: "order")
            
            newPolygon.addToNodes(newNode)
        }
    }
    
    do {
        try context.save()
    } catch {
        print("Failed saving")
    }
    
}

func fetchMyPuzzle(name: String) -> [Puzzle] {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let puzzleFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Puzzle")
    
    do {
        let fetchedPuzzles = try context.fetch(puzzleFetchRequest) as! [Puzzle]
        for p in fetchedPuzzles {
            print("node",p.polygons)
        }
        return fetchedPuzzles
    } catch {
        fatalError("Failed to fetch puzzle: \(error)")
    }
    
}

func buildDraggablePolygonsFromPuzzle(puzzle: Puzzle) -> [DraggablePolygon] {
    
    var newPolygons: [DraggablePolygon] = []
    
    
    for p in puzzle.polygons!{
        
        let pz = p as! Polygon
        
        let nodes = pz.nodes

        let newPolygon = buildDraggablePolygonFromPrimitiveNodes(pNodes: nodes)
        newPolygon.originalOrigin = CGPoint(x: CGFloat(pz.originalX), y: CGFloat(pz.originalY))
    
        newPolygons.append(newPolygon)
        
    }
    return newPolygons
}

func buildDraggablePolygonFromPrimitiveNodes(pNodes: NSSet?) -> DraggablePolygon {
    
    var newPNodes: [PrimitiveNode] = []
    var newNodes: [Node] = []
    
    // Apparently I can't cast the whole array as PrimitiveNode at once. One at a time works though.
    for pN in pNodes! {
        let ppN = pN as! PrimitiveNode
        newPNodes.append(ppN)
    }
    
    newPNodes.sort(by: {$0.order < $1.order})
    
    for pN in newPNodes {
        let newNode = buildNodeFromCoreData(pNode: pN)
        newNodes.append(newNode)
    }
    
    let newVertices = convertNodesToPoints(_nodes: newNodes)
    
    let newSize = size(of: newVertices)
    
    let newFrame = CGRect(origin: PointZero, size: newSize)
    
    let newDraggablePolygon = DraggablePolygon(frame: newFrame)
    newDraggablePolygon.nodes = newNodes
    newDraggablePolygon.config(vertices: newVertices)
    
    return newDraggablePolygon
}

func buildNodeFromCoreData(pNode: PrimitiveNode) -> Node {
    
    let sister = Int(pNode.sisterIndex)
    let x = CGFloat(pNode.xCoordinate)
    let y = CGFloat(pNode.yCoordinate)
    let location = CGPoint(x: x, y: y)

    return Node(_location: location, _sister: sister)
    
}

