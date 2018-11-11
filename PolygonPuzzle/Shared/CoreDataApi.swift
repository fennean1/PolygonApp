//
//  Api.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 10/1/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.


// Keep an eye on this:
///https://cocoacasts.com/core-data-relationships-and-delete-rules

import Foundation
import UIKit
import CoreData

class cachedPuzzle {
    var puzzleName = "name"
    var polygons: [DraggablePolygon] = []
    var puzzleView = UIView()
    
    init(name: String,polygons: [DraggablePolygon],dim: CGFloat) {
        
        puzzleView.frame = CGRect(x: 0, y: 0, width: dim, height: dim)
        puzzleName = name
        
        for p in polygons {
            p.frame.origin = CGPoint(x: p.originalOrigin.x,y: p.originalOrigin.y)
            p.drawTheLayer()
            p.cancelDragging = true
            puzzleView.addSubview(p)
        }
    }
    
}


/// HEY YOU! WRITE YOUR "FIRST LOAD" FUNCTION HERE THAT RETURNS TRUE IF YOU"RE IN YOUR FIRST LOAD HAHA. It mus

func deleteFirstLoad() {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    let firstLoadFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FirstLoad")
    
    if let firstLoadState = try? context.fetch(firstLoadFetchRequest) {
        print("firstLoadState",firstLoadState)
        
        for object in firstLoadState {
            print("deleting an object here")
            context.delete(object as! NSManagedObject)
        }
    }
}


func deleteAllPuzzles() {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    let puzzleFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Puzzle")
    
    if let puzzle = try? context.fetch(puzzleFetchRequest) {
        print("firstLoadState",puzzle)
        
        for object in puzzle {
            print("deleting an object here")
            context.delete(object as! NSManagedObject)
        }
    }
}

func firstLoad() -> Bool {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    // If this fails, should I also check to see if I have an saved pieces or polygons?
    
    let firstLoadFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FirstLoad")
    
    if let firstLoadState = try? context.fetch(firstLoadFetchRequest) {
        print("firstLoadState",firstLoadState)
        
        // Check to see if it's empty.
        if let loadFirst = firstLoadState.first {
            let x = loadFirst as! FirstLoad
            print("NOT THE FIRST LOAD",x.loaded)
            return false
        }
        // If it is empty, insert an entity.
        else {
            print("TOTALLY THE FIRST LOAD")
            let loadEntity = NSEntityDescription.entity(forEntityName: "FirstLoad", in: context)
            let newLoad = NSManagedObject(entity: loadEntity!, insertInto: context) as! FirstLoad
            newLoad.setValue(true, forKey: "loaded")
            return true
        }
    } else
    {
       print("fetching first load failed")
    }
    return false
}


func initPuzzleCollectionViewDataSource(puzzles: [Puzzle],dim: CGFloat) -> [cachedPuzzle] {
    var cached: [cachedPuzzle] = []
    for p in puzzles {
        let pols = buildDraggablePolygonsFromPuzzle(puzzle: p,dim: dim)
        let newCache = cachedPuzzle(name: p.name!, polygons: pols, dim: dim)
        cached.append(newCache)
    }
    return cached
}

func fetchAllPuzzles() -> [Puzzle]? {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    let puzzleFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Puzzle")
    
    if let puzzles = try? context.fetch(puzzleFetchRequest) {
        return puzzles as! [Puzzle]
    } else
    {
        print("No puzzles!")
        return nil
    }
}

func savePuzzleToCoreData(polygons: [DraggablePolygon], name: String,dim: CGFloat) {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext

    
    /*
    let puzzleFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Puzzle")
    if let result = try? context.fetch(puzzleFetchRequest) {
        for object in result {
            context.delete(object as! NSManagedObject)
        }
    }
 
 */
    
    print("creating puzzle entity")
    let puzzleEntity = NSEntityDescription.entity(forEntityName: "Puzzle", in: context)
    print("creating newPuzzle")
    let newPuzzle = NSManagedObject(entity: puzzleEntity!, insertInto: context) as! Puzzle
    print("setting value for new puzzle")
    newPuzzle.setValue(name, forKey: "name")
    
    for p in polygons {
        
        let polygonEntity = NSEntityDescription.entity(forEntityName: "Polygon", in: context)
        let newPolygon = NSManagedObject(entity: polygonEntity!, insertInto: context) as! Polygon
        newPolygon.setValue(p.originalOrigin.x/dim, forKey: "originalX")
        newPolygon.setValue(p.originalOrigin.y/dim, forKey: "originalY")
        
        newPuzzle.addToPolygons(newPolygon)
        
        for (i,n) in p.nodes!.enumerated() {
            
            let ex = Float(n.location.x/dim)
            let why = Float(n.location.y/dim)
            
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
        return fetchedPuzzles
    } catch {
        fatalError("Failed to fetch puzzle: \(error)")
    }
    
}

func buildDraggablePolygonsFromPuzzle(puzzle: Puzzle,dim: CGFloat) -> [DraggablePolygon] {
    
    var newPolygons: [DraggablePolygon] = []
    
    
    for p in puzzle.polygons!{
        
        let pz = p as! Polygon
   
        let nodes = pz.nodes

        let newPolygon = buildDraggablePolygonFromPrimitiveNodes(pNodes: nodes,dim: dim)
        
        // SCALING ORIGINS
        let scaledOriginalOriginX = CGFloat(pz.originalX*Float(dim))
        let scaledOriginalOriginY = CGFloat(pz.originalY*Float(dim))
        
        newPolygon.originalOrigin = CGPoint(x: scaledOriginalOriginX, y: scaledOriginalOriginY)
        
        newPolygons.append(newPolygon)
        
    }
    return newPolygons
}

func buildDraggablePolygonFromPrimitiveNodes(pNodes: NSSet?,dim: CGFloat) -> DraggablePolygon {
    
    var newPNodes: [PrimitiveNode] = []
    var newNodes: [Node] = []
    
    // Apparently I can't cast the whole array as PrimitiveNode at once. One at a time works though.
    for pN in pNodes! {
        let ppN = pN as! PrimitiveNode
        newPNodes.append(ppN)
    }
    
    newPNodes.sort(by: {$0.order < $1.order})
    
    for pN in newPNodes {
        let newNode = buildNodeFromCoreData(pNode: pN,dim: dim)
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

func buildNodeFromCoreData(pNode: PrimitiveNode,dim: CGFloat) -> Node {
    
    let sister = Int(pNode.sisterIndex)
    let x = CGFloat(pNode.xCoordinate*Float(dim))
    let y = CGFloat(pNode.yCoordinate*Float(dim))
    let location = CGPoint(x: x, y: y)

    return Node(_location: location, _sister: sister)
    
}

