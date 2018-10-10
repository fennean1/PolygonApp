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
    
    for p in polygons {
        
        let polygonEntity = NSEntityDescription.entity(forEntityName: "Polygon", in: context)
        let newPolygon = NSManagedObject(entity: polygonEntity!, insertInto: context) as! Polygon
        
        
        for n in p.nodes! {
            
            let ex = Float(n.location.x)
            let why = Float(n.location.y)
    
            let nodeEntity = NSEntityDescription.entity(forEntityName: "PrimitiveNode", in: context)
            let newNode = NSManagedObject(entity: nodeEntity!, insertInto: context) as! PrimitiveNode
            newNode.setValue(ex, forKey: "xCoordinate")
            newNode.setValue(why, forKey: "yCoordinate")
            
            newPolygon.addToNodes(newNode)
     
        }
    
    }
    
    do {
        try context.save()
    } catch {
        print("Failed saving")
    }
    
}

func fetchMyPuzzle() -> [Polygon] {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let puzzleFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Polygon")
    
    do {
        let fetchedPuzzle = try context.fetch(puzzleFetchRequest) as! [Polygon]
        for p in fetchedPuzzle {
            print("node",p.nodes)
        }
        return fetchedPuzzle
    } catch {
        fatalError("Failed to fetch puzzle: \(error)")
    }
    
}

